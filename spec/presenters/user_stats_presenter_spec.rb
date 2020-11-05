describe UserStatsPresenter do
  subject { UserStatsPresenter.new(args) }
  let(:args) do
    { user: user,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date }
  end

  let(:user) { create(:user) }
  let(:filter_start_date) { Time.zone.today - 1.year }
  let(:filter_end_date) { Time.zone.today }

  before :all do
    Timecop.freeze(Time.zone.local(2020, 10, 30, 17, 59, 59))
  end

  after :all do
    Timecop.return
  end

  context 'when user has no time range values' do
    describe 'average_weekly_planned' do
      it 'returns nil' do
        expect(subject.average_weekly_planned).to eq nil
      end
    end

    describe 'average_weekly_actual' do
      it 'returns nil' do
        expect(subject.average_weekly_actual).to eq nil
      end
    end

    describe 'percentage_delivered' do
      it 'returns nil' do
        expect(subject.percentage_delivered).to eq nil
      end
    end
  end

  context 'when user has time range values' do
    let!(:planned_activity) do
      create(
        :plan,
        user_id: user.id,
        start_date: plan_start_time,
        end_date: plan_end_time,
        activities: [create(:activity)]
      )
    end
    let!(:actual_activity) do
      create(:time_range,
             user_id: user.id,
             time_range_type_id: TimeRangeType.actual_type.id,
             start_time: actual_start_time,
             end_time: actual_end_time,
             value: actual_value)
    end
    let(:actual_value) { 6240 } # 2 hours * 52 weeks in minutes.
    let(:plan_start_time) { 1.year.ago }
    let(:plan_end_time) { Time.zone.now }
    let(:actual_start_time) { 1.year.ago }
    let(:actual_end_time) { Time.zone.now }

    describe 'status' do
      context 'when no planned data' do
        let!(:planned_activity) { nil }
        it 'returns Unknown' do
          expect(subject.status).to eq 'Unknown'
        end
      end
      context 'when no actual data' do
        let!(:actual_activity) { nil }
        it 'returns Unknown' do
          expect(subject.status).to eq 'Unknown'
        end
      end
      context 'when actual data with 0 value' do
        let(:actual_value) { 0 }
        it 'returns Really Under' do
          expect(subject.status).to eq 'Really Under'
        end
      end
      context 'when 1 to 49' do
        let(:actual_value) { 6115 } # 49%
        it 'returns Really Under' do
          expect(subject.status).to eq 'Really Under'
        end
      end
      context 'when 50 to 79' do
        let(:actual_value) { 6240 } # 50%
        it 'returns Under' do
          expect(subject.status).to eq 'Under'
        end
      end
      context 'when 80 to 119' do
        let(:actual_value) { 9984 } # 80%
        it 'returns About Right' do
          expect(subject.status).to eq 'About Right'
        end
      end
      context 'when 120+' do
        let(:actual_value) { 14_976 } # 120%
        it 'returns Over' do
          expect(subject.status).to eq 'Over'
        end
      end
    end

    context 'within filter time range' do
      describe 'average_weekly_planned' do
        it 'returns average weekly planned values for the time range' do
          expect(subject.average_weekly_planned).to eq 238.0
        end
      end

      describe 'average_weekly_actual' do
        it 'returns average weekly actual values for the time range' do
          expect(subject.average_weekly_actual).to eq 119.0
        end
      end

      describe 'percentage_delivered' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.percentage_delivered).to eq 50
        end
      end
    end

    context 'when no filter (it defaults to last 12 months)' do
      let(:args) { { user: user } }

      describe 'average_weekly_planned' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.average_weekly_planned).to eq 238.0
        end
      end

      describe 'average_weekly_actual' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.average_weekly_actual).to eq 119.0
        end
      end

      describe 'percentage_delivered' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.percentage_delivered).to eq 50
        end
      end
    end

    context 'when planned is outside filter time range' do
      let(:plan_start_time) { 1.year.ago - 2.days }
      let(:plan_end_time) { 1.year.ago - 1.day }

      describe 'average_weekly_planned' do
        it 'returns nil as no planned data' do
          expect(subject.average_weekly_planned).to eq nil
        end
      end

      describe 'average_weekly_actual' do
        it 'returns average weekly actual values for the time range' do
          expect(subject.average_weekly_actual).to eq 119
        end
      end

      describe 'percentage_delivered' do
        it 'returns nil as no planned data' do
          expect(subject.percentage_delivered).to eq nil
        end
      end
    end

    context 'when actual is outside filter time range' do
      let(:actual_start_time) { Time.zone.tomorrow }
      let(:actual_end_time) { Time.zone.tomorrow + 1.day }

      describe 'average_weekly_planned' do
        it 'returns average weekly planned values for the time range' do
          expect(subject.average_weekly_planned).to eq 238.0
        end
      end

      describe 'average_weekly_actual' do
        it 'returns nil as no actual data' do
          expect(subject.average_weekly_actual).to eq nil
        end
      end

      describe 'percentage_delivered' do
        it 'returns nil as no actual data' do
          expect(subject.percentage_delivered).to eq nil
        end
      end
    end
  end
end
