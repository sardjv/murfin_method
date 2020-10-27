describe ScheduleBuilder do
  let(:start_time) { Time.current }
  let(:rules) { [{ type: 'weekly', day: 'monday' }] }

  subject { ScheduleBuilder.call(start_time: start_time, rules: rules) }

  it 'builds a schedule' do
    expect(subject).to be_an(IceCube::Schedule)
    expect(subject.rrules.count).to eq(rules.count)

    subject.rrules.each do |rule|
      expect(rule.to_s).to eq('Weekly on Mondays')
    end
  end
end
