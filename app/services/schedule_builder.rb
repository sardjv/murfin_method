class ScheduleBuilder
  # Rules should be an array: [{ type: 'weekly', day: 'monday' }]
  def self.call(schedule: nil, start_time: nil, end_time: nil, rules: nil)
    schedule ||= IceCube::Schedule.new
    schedule = set_start_time(schedule: schedule, value: start_time)
    schedule = set_end_time(schedule: schedule, value: end_time)
    set_rules(schedule: schedule, value: rules)
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
      schedule.add_recurrence_rule(IceCube::Rule.send(rule[:type]).day(rule[:day].to_sym))
    end

    schedule
  end
end
