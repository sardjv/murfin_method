class ScheduleParser
  # Pass an IceCube::Schedule.
  def self.call(schedule:)
    {
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
