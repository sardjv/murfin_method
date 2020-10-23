describe ScheduleParser do
  let(:schedule) { ScheduleBuilder.call(rules: [{ type: 'weekly', day: 'monday' }]) }

  subject { ScheduleParser.call(schedule: schedule) }

  it 'parses a schedule' do
    expect(subject[:rules].count).to eq(1)
    expect(subject[:rules].first[:type]).to eq('weekly')
    expect(subject[:rules].first[:day]).to eq('monday')
  end
end
