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
      create(:time_range,
             user_id: user.id,
             time_range_type_id: TimeRangeType.plan_type.id,
             start_time: plan_start_time,
             end_time: plan_end_time,
             value: plan_value)
    end
    let!(:actual_activity) do
      create(:time_range,
             user_id: user.id,
             time_range_type_id: TimeRangeType.actual_type.id,
             start_time: actual_start_time,
             end_time: actual_end_time,
             value: actual_value)
    end
    let(:plan_value) { 1500 }
    let(:actual_value) { 630 }
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
      context 'when planned data with 0 value' do
        let(:plan_value) { 0 }
        it 'returns Really Under' do
          expect(subject.status).to eq 'Really Under'
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
        let(:plan_value) { 100 }
        let(:actual_value) { 49 }
        it 'returns Really Under' do
          expect(subject.status).to eq 'Really Under'
        end
      end
      context 'when 50 to 79' do
        let(:plan_value) { 100 }
        let(:actual_value) { 50 }
        it 'returns Under' do
          expect(subject.status).to eq 'Under'
        end
      end
      context 'when 80 to 119' do
        let(:plan_value) { 100 }
        let(:actual_value) { 80 }
        it 'returns About Right' do
          expect(subject.status).to eq 'About Right'
        end
      end
      context 'when 120+' do
        let(:plan_value) { 100 }
        let(:actual_value) { 120 }
        it 'returns Over' do
          expect(subject.status).to eq 'Over'
        end
      end
    end

    context 'within filter time range' do
      describe 'average_weekly_planned' do
        it 'returns average weekly planned values for the time range' do
          expect(subject.average_weekly_planned).to eq 28.6
        end
      end

      describe 'average_weekly_actual' do
        it 'returns average weekly actual values for the time range' do
          expect(subject.average_weekly_actual).to eq 12
        end
      end

      describe 'percentage_delivered' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.percentage_delivered).to eq 42
        end
      end
    end

    context 'when no filter (it defaults to last 12 months)' do
      let(:args) { { user: user } }

      describe 'average_weekly_planned' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.average_weekly_planned).to eq 28.6
        end
      end

      describe 'average_weekly_actual' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.average_weekly_actual).to eq 12
        end
      end

      describe 'percentage_delivered' do
        it 'returns the percentage delivered over the time range' do
          expect(subject.percentage_delivered).to eq 42
        end
      end
    end

    context 'when planned is outside filter time range' do
      let(:plan_start_time) { 1.year.ago - 1.day }
      let(:plan_end_time) { 1.year.ago - 1.day }

      describe 'average_weekly_planned' do
        it 'returns nil as no planned data' do
          expect(subject.average_weekly_planned).to eq nil
        end
      end

      describe 'average_weekly_actual' do
        it 'returns average weekly actual values for the time range' do
          expect(subject.average_weekly_actual).to eq 12
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
      let(:actual_end_time) { Time.zone.tomorrow }

      describe 'average_weekly_planned' do
        it 'returns average weekly planned values for the time range' do
          expect(subject.average_weekly_planned).to eq 28.6
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
