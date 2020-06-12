class FakeGraphDataJob < ApplicationJob
  queue_as :default

  def perform(story:, user:, time_range_type:, graph_start_time:, graph_end_time:, unit:)
    case story
    when :static
      start_time = graph_start_time
      value = rand(1..100)
      while start_time < graph_end_time
        end_time = start_time + 1.send(unit) - 1.second

        FactoryBot.create(
          :time_range,
          user_id: user.id,
          time_range_type_id: time_range_type.id,
          value: value,
          start_time: start_time,
          end_time: end_time
        )

        start_time = end_time + 1.second
      end
    end
  end
end
