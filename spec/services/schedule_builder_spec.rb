describe ScheduleBuilder do
  let(:start_time) { Time.current }
  let(:end_time) { start_time + 1.hour }
  let(:rules) { [{ type: 'weekly', days: ['monday'] }] }

  subject do
    ScheduleBuilder.call(
      start_time: start_time,
      end_time: end_time,
      rules: rules
    )
  end

  it 'builds a schedule' do
    expect(subject).to be_an(IceCube::Schedule)
    expect(subject.start_time).to eq(start_time)
    expect(subject.end_time).to eq(end_time)
    expect(subject.rrules.count).to eq(rules.count)

    subject.rrules.each do |rule|
      expect(rule.to_s).to eq('Weekly on Mondays')
    end
  end

  describe 'minutes_per_week' do
    subject do
      ScheduleBuilder.call(
        minutes_per_week: minutes_per_week.to_s
      )
    end

    context 'when 7 hours' do
      let(:minutes_per_week) { 7 * 60 }

      it 'builds a schedule' do
        expect(subject).to be_an(IceCube::Schedule)
        expect(subject.start_time).to eq(Time.zone.local(1, 1, 1, 9, 0))
        expect(subject.end_time).to eq(Time.zone.local(1, 1, 1, 10, 0))
        expect(subject.rrules.count).to eq(1)

        subject.rrules.each do |rule|
          expect(rule.to_s).to eq('Weekly on Sundays, Mondays, Tuesdays, Wednesdays, Thursdays, Fridays, and Saturdays')
        end
      end
    end

    context 'when 8 hours every day' do
      let(:minutes_per_week) { 7 * 8 * 60 }

      it 'splits across the week' do
        expect(subject.start_time).to eq(Time.zone.local(1, 1, 1, 9, 0))
        expect(subject.end_time).to eq(Time.zone.local(1, 1, 1, 17, 0))
        expect(subject.rrules.count).to eq(1)

        subject.rrules.each do |rule|
          expect(rule.to_s).to eq('Weekly on Sundays, Mondays, Tuesdays, Wednesdays, Thursdays, Fridays, and Saturdays')
        end
      end
    end
  end

  context 'when more than 8 hours every day' do
    let(:minutes_per_week) { (7 * 8 * 60) + 1 }

    it { expect { ScheduleBuilder.call(minutes_per_week: minutes_per_week) }.to raise_error(MaxDurationError) }
  end
end
