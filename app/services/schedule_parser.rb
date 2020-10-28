class ScheduleParser
  # Pass an IceCube::Schedule.
  def self.call(schedule:)
    {
      start_time: schedule.start_time,
      end_time: schedule.end_time,
      rules: schedule.rrules.map do |rule|
        { type: type(rule), day: day(rule) }
      end
    }
  end

  private_class_method def self.type(rule)
    case rule
    when IceCube::WeeklyRule then 'weekly'
    end
  end

  private_class_method def self.day(rule)
    %w[
      sunday
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
    ][rule.to_hash[:validations][:day].first]
  end
end
