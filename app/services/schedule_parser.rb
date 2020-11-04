class ScheduleParser
  # Pass an IceCube::Schedule.
  def self.call(schedule:)
    {
      start_time: schedule.start_time,
      end_time: schedule.end_time,
      rules: schedule.rrules.map do |rule|
        { type: type(rule: rule), days: days(rule: rule) }
      end,
      minutes_per_week: minutes_per_week(schedule: schedule)
    }
  end

  private_class_method def self.type(rule:)
    case rule
    when IceCube::WeeklyRule then 'weekly'
    else raise UnhandledRuleError
    end
  end

  private_class_method def self.days(rule:)
    %w[
      sunday
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
    ].values_at(*rule.to_hash[:validations][:day])
  end

  private_class_method def self.minutes_per_week(schedule:)
    schedule.rrules.sum do |rule|
      raise UnhandledRuleError unless type(rule: rule) == 'weekly'

      days(rule: rule).count * (schedule.end_time - schedule.start_time) / 60
    end
  end
end
