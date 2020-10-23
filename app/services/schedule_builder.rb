class ScheduleBuilder
  # Pass an array of rules: [{ type: 'weekly', day: 'monday' }]
  def self.call(rules:)
    IceCube::Schedule.new do |s|
      rules.each do |rule|
        s.add_recurrence_rule(IceCube::Rule.send(rule[:type]).day(rule[:day].to_sym))
      end
    end
  end
end
