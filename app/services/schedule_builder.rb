class ScheduleBuilder
  # Rules should be an array: [{ type: 'weekly', day: 'monday' }]
  def self.call(schedule: nil, start_time: nil, end_time: nil, rules: nil)
    schedule ||= IceCube::Schedule.new
    schedule.start_time = start_time if start_time
    schedule.end_time = end_time if end_time
    if rules
      schedule.rrules.each do |rule|
        schedule.remove_recurrence_rule(rule)
      end
      rules&.each do |rule|
        schedule.add_recurrence_rule(IceCube::Rule.send(rule[:type]).day(rule[:day].to_sym))
      end
    end
    schedule
  end
end
