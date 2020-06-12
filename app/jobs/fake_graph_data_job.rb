# Fake data generator! Useful for generating data with realistic stories like seasonality for demos.
class FakeGraphDataJob < ApplicationJob
  queue_as :default

  def perform(story:, user_id:, time_range_type_id:, graph_start_time:, graph_end_time:, unit:, volatility:)
    user = User.find(user_id)
    time_range_type = TimeRangeType.find(time_range_type_id)

    time_ranges = build_static(
      user: user,
      time_range_type: time_range_type,
      graph_start_time: graph_start_time,
      graph_end_time: graph_end_time,
      unit: unit
    )
    direction = dip_or_spike

    case story
    when :static
      time_ranges.each do |time_range|
        time_range.value = adjust(value: time_range.value, volatility: volatility, direction: direction)
      end
    when :seasonal_summer_and_christmas
      months = %w[June July December]

      time_ranges.each do |time_range|
        if months.include?(time_range.start_time.strftime('%B'))
          time_range.value = adjust(value: time_range.value, volatility: volatility, direction: direction)
        end
      end
    end

    time_ranges.each(&:save)
  end

  # A flat graph - the same value in each time_range.
  def build_static(user:, time_range_type:, graph_start_time:, graph_end_time:, unit:)
    result = []
    start_time = graph_start_time
    value = rand(1..100)

    while start_time < graph_end_time
      end_time = start_time + 1.send(unit) - 1.second

      # If there's an existing time range of a different type, assume that's a plan and track it.
      plan = TimeRange.where.not(
        time_range_type: time_range_type
      ).where(
        user: user,
        start_time: start_time
      ).first

      result << FactoryBot.build(
        :time_range,
        user_id: user.id,
        time_range_type_id: time_range_type.id,
        value: plan.try(:value) || value,
        start_time: start_time,
        end_time: end_time
      )

      start_time = end_time + 1.second
    end
    result
  end

  # Randomly choose dip or spike.
  def dip_or_spike
    %i[dip spike variable].sample
  end

  # Adjust a value according to a given volatility between 0 and 1.0.
  # From: https://stackoverflow.com/questions/8597731/are-there-known-techniques-to-generate-realistic-looking-fake-stock-data
  def adjust(value:, volatility:, direction:)
    change_percent = 2 * volatility * rand
    change_percent -= (2 * volatility) if change_percent > volatility

    case direction
    when :dip
      change_percent = change_percent = -change_percent.abs
    when :spike
      change_percent = change_percent.abs
    end

    change_amount = value * change_percent
    new_value = value + change_amount
    new_value.round
  end
end
