class ScheduleBuilder
  # Rules should be an array: [{ type: 'weekly', day: 'monday' }]
  def self.call(schedule: nil, start_time: nil, end_time: nil, rules: nil, minutes_per_week: nil)
    schedule ||= IceCube::Schedule.new
    schedule = set_start_time(schedule: schedule, value: start_time)
    schedule = set_end_time(schedule: schedule, value: end_time)
    schedule = set_rules(schedule: schedule, value: rules)
    set_minutes_per_week(schedule: schedule, value: minutes_per_week)
  end

  private_class_method def self.set_start_time(schedule:, value:)
    return schedule unless value

    schedule.start_time = value

    schedule
  end

  private_class_method def self.set_end_time(schedule:, value:)
    return schedule unless value

    schedule.end_time = value

    schedule
  end

  private_class_method def self.set_rules(schedule:, value:)
    return schedule unless value

    schedule.rrules.each do |rule|
      schedule.remove_recurrence_rule(rule)
    end
    value.each do |rule|
      schedule.add_recurrence_rule(IceCube::Rule.send(rule[:type]).day(*rule[:days].map(&:to_sym)))
    end

    schedule
  end

  # Overrides any existing rules.
  private_class_method def self.set_minutes_per_week(schedule:, value:)
    return schedule unless value

    max_minutes_per_day = 480.0 # 8 hours.

    # Limit to 8 hours per day - arbitrary, but gives a hard limit to schedules.
    raise MaxDurationError unless value <= (max_minutes_per_day * 7)

    number_of_days = (value / max_minutes_per_day).round
    minutes_per_day = value / number_of_days # Spread minutes evenly across the days.
    days = %w[monday tuesday wednesday thursday friday saturday sunday][0...number_of_days]

    schedule = set_start_time(schedule: schedule, value: Time.zone.local(1, 1, 1, 9, 0))
    schedule = set_end_time(schedule: schedule, value: schedule.start_time + minutes_per_day.minutes)
    set_rules(schedule: schedule, value: [{ type: 'weekly', days: days }])
  end
end
