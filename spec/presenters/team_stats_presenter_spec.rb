describe TeamStatsPresenter do
  subject { TeamStatsPresenter.new(args) }
  let(:args) do
    { users: users,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date }
  end

  let(:users) { create_list(:user, 10) }
  let(:filter_start_date) { Time.zone.today - 1.year }
  let(:filter_end_date) { Time.zone.today }

  context 'when users have no time range values' do
    describe 'average_planned_per_month' do
      it 'returns 0' do
        expect(subject.average_planned_per_month).to eq 0
      end
    end

    describe 'average_actual_per_month' do
      it 'returns 0' do
        expect(subject.average_actual_per_month).to eq 0
      end
    end

    describe 'percentage_delivered_per_month' do
      it 'returns 0' do
        expect(subject.percentage_delivered_per_month).to eq 0
      end
    end
  end

  # context 'when users hav time range values' do
  #   let!(:planned_activity) do
  #     create(:time_range,
  #            user_id: user.id,
  #            time_range_type_id: TimeRangeType.plan_type.id,
  #            start_time: plan_start_time,
  #            end_time: plan_end_time,
  #            value: 1500)
  #   end
  #   let!(:actual_activity) do
  #     create(:time_range,
  #            user_id: user.id,
  #            time_range_type_id: TimeRangeType.actual_type.id,
  #            start_time: actual_start_time,
  #            end_time: actual_end_time,
  #            value: 630)
  #   end
  #   let(:plan_start_time) { 1.year.ago }
  #   let(:plan_end_time) { Time.zone.now }
  #   let(:actual_start_time) { 1.year.ago }
  #   let(:actual_end_time) { Time.zone.now }

  #   context 'within filter time range' do
  #     describe 'average_weekly_planned' do
  #       it 'returns avergae weekly planned values for the time range' do
  #         expect(subject.average_weekly_planned).to eq 29
  #       end
  #     end

  #     describe 'average_weekly_actual' do
  #       it 'returns avergae weekly actual values for the time range' do
  #         expect(subject.average_weekly_actual).to eq 12
  #       end
  #     end

  #     describe 'percentage_delivered' do
  #       it 'returns the percentage delievered over the time range' do
  #         expect(subject.percentage_delivered).to eq 42
  #       end
  #     end
  #   end

  #   context 'when no filter defaults to last 12 months' do
  #     let(:filter_start_date) {}
  #     let(:filter_end_date) {}

  #     describe 'average_weekly_planned' do
  #       it 'returns 0' do
  #         expect(subject.average_weekly_planned).to eq 29
  #       end
  #     end

  #     describe 'average_weekly_actual' do
  #       it 'returns 0' do
  #         expect(subject.average_weekly_actual).to eq 12
  #       end
  #     end

  #     describe 'percentage_delivered' do
  #       it 'returns 0' do
  #         expect(subject.percentage_delivered).to eq 42
  #       end
  #     end
  #   end

  #   context 'when planned is outside filter time range' do
  #     let(:plan_start_time) { 1.year.ago - 1.day }
  #     let(:plan_end_time) { 1.year.ago - 1.day }

  #     describe 'average_weekly_planned' do
  #       it 'returns avergae weekly planned values for the time range' do
  #         expect(subject.average_weekly_planned).to eq 0
  #       end
  #     end

  #     describe 'average_weekly_actual' do
  #       it 'returns avergae weekly actual values for the time range' do
  #         expect(subject.average_weekly_actual).to eq 12
  #       end
  #     end

  #     describe 'percentage_delivered' do
  #       it 'returns the percentage delievered over the time range' do
  #         expect(subject.percentage_delivered).to eq 0
  #       end
  #     end
  #   end

  #   context 'actual is outside filter time range' do
  #     let(:actual_start_time) { Time.zone.tomorrow }
  #     let(:actual_end_time) { Time.zone.tomorrow }

  #     describe 'average_weekly_planned' do
  #       it 'returns avergae weekly planned values for the time range' do
  #         expect(subject.average_weekly_planned).to eq 29
  #       end
  #     end

  #     describe 'average_weekly_actual' do
  #       it 'returns avergae weekly actual values for the time range' do
  #         expect(subject.average_weekly_actual).to eq 0
  #       end
  #     end

  #     describe 'percentage_delivered' do
  #       it 'returns the percentage delievered over the time range' do
  #         expect(subject.percentage_delivered).to eq 0
  #       end
  #     end
  #   end
  # end
end
