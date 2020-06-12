class FakeGraphDataJob < ApplicationJob
  queue_as :default

  def perform(story:, user:, time_range_type:, graph_start_time:, graph_end_time:, unit:, volatility:)
    time_ranges = build_static(
      user: user,
      time_range_type: time_range_type,
      graph_start_time: graph_start_time,
      graph_end_time: graph_end_time,
      unit: unit
    )

    case story
    when :static
      time_ranges.each do |time_range|
        time_range.value = adjust(value: time_range.value, volatility: volatility)
      end
    when :seasonal_summer_and_christmas
      direction = dip_or_spike
      months = ['June', 'July', 'December']

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

      result << FactoryBot.build(
        :time_range,
        user_id: user.id,
        time_range_type_id: time_range_type.id,
        value: value,
        start_time: start_time,
        end_time: end_time
      )

      start_time = end_time + 1.second
    end
    result
  end

  # Randomly choose dip or spike.
  def dip_or_spike
    [true, false].sample ? :dip : :spike
  end

  # Adjust a value according to a given volatility between 0 and 1.0.
  # From: https://stackoverflow.com/questions/8597731/are-there-known-techniques-to-generate-realistic-looking-fake-stock-data
  def adjust(value:, volatility:, direction: :random)
    change_percent = 2 * volatility * rand
    if (change_percent > volatility)
      change_percent -= (2 * volatility)
    end

    case direction
    when :dip
      change_percent = change_percent = -(change_percent).abs
    when :spike
      change_percent = (change_percent).abs
    end

    change_amount = value * change_percent
    new_value = value + change_amount
    new_value.round
  end
end
