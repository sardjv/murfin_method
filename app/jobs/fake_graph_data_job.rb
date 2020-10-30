# Fake data generator! Useful for generating data with realistic stories like seasonality for demos.
class FakeGraphDataJob < ApplicationJob
  queue_as :default

  def perform(story:, user_id:, time_range_type_id:, start:, volatility:)
    send(
      story,
      time_ranges: build_static(
        user_id: user_id,
        time_range_type_id: time_range_type_id,
        start: start,
        random_value: rand(1..100)
      ),
      volatility: volatility
    )
  end

  def static(time_ranges:, volatility:)
    direction = dip_or_spike
    time_ranges.each do |time_range|
      time_range.value = adjust(
        value: time_range.value,
        volatility: volatility,
        direction: direction
      )
      time_range.save
    end
  end

  def seasonal_summer_and_christmas(time_ranges:, volatility:)
    direction = dip_or_spike
    time_ranges.each do |time_range|
      summer_or_christmas = overlaps?(time_range, %w[June July December])
      time_range.value = adjust(
        value: time_range.value,
        volatility: summer_or_christmas ? volatility : 0.04,
        direction: summer_or_christmas ? direction : :variable
      )
      time_range.save
    end
  end

  def overlaps?(time_range, months)
    months.include?(time_range.start_time.strftime('%B'))
  end

  # A flat graph - the same value in each time_range.
  def build_static(user_id:, time_range_type_id:, start:, random_value:)
    mondays_in_year(start: start).map do |start_time|
      build_time_range(
        start_time: start_time,
        user_id: user_id,
        time_range_type_id: time_range_type_id,
        random_value: random_value
      )
    end
  end

  def build_time_range(start_time:, user_id:, time_range_type_id:, random_value:)
    end_time = start_time + 1.send(:week) - 1.second
    value = plan(user_id: user_id, start_time: start_time, end_time: end_time)

    FactoryBot.build(
      :time_range,
      user_id: user_id,
      time_range_type_id: time_range_type_id,
      value: value || random_value,
      start_time: start_time,
      end_time: end_time
    )
  end

  def mondays_in_year(start:)
    (start.beginning_of_year..start.end_of_year).to_a.select { |d| d.wday == 1 }
  end

  def plan(user_id:, start_time:, end_time:)
    relevant = user_plan(user_id: user_id).select do |a|
      Intersection.call(
        a_start: a.start_time,
        a_end: a.end_time,
        b_start: start_time,
        b_end: end_time
      ).positive?
    end
    relevant.any? ? relevant.sum(&:value) : nil
  end

  def user_plan(user_id:)
    @user_time_ranges ||= {}
    @user_time_ranges[user_id] ||= Plan.where(user_id: user_id).flat_map(&:to_time_ranges)
  end

  def dip_or_spike
    %i[dip spike].sample
  end

  # Adjust a value according to a given volatility between 0 and 1.0.
  # From: https://stackoverflow.com/questions/8597731/are-there-known-techniques-to-generate-realistic-looking-fake-stock-data
  def adjust(value:, volatility:, direction:)
    change_percent = 2 * volatility * rand
    change_percent -= (2 * volatility) if change_percent > volatility
    change_percent = set_direction(value: change_percent, direction: direction)
    change_amount = value * change_percent
    new_value = value + change_amount
    new_value.round
  end

  def set_direction(value:, direction:)
    case direction
    when :dip
      -value.abs
    when :spike
      value.abs
    else
      value
    end
  end
end
