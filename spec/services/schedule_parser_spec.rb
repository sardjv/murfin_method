describe ScheduleParser do
  let(:start_time) { Time.current }
  let(:end_time) { start_time + 1.hour }
  let(:rules) { [{ type: 'weekly', days: ['monday'] }] }
  let(:schedule) do
    ScheduleBuilder.call(
      start_time: start_time,
      end_time: end_time,
      rules: rules
    )
  end

  subject { ScheduleParser.call(schedule: schedule) }

  it 'parses a schedule' do
    expect(subject[:start_time]).to eq(start_time)
    expect(subject[:end_time]).to eq(end_time)
    expect(subject[:rules].count).to eq(1)
    expect(subject[:rules].first[:type]).to eq(rules.first[:type])
    expect(subject[:rules].first[:days]).to eq(rules.first[:days])
  end
end
