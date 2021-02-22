describe UserStatsPresenter, freeze: Time.zone.local(2020, 11, 9, 0, 42) do
  subject { UserStatsPresenter.new(user: user) }
  let(:user) { create(:user) }

  context 'when user has time range values' do
    let!(:time_range) do
      create(:time_range,
             user_id: user.id,
             time_range_type_id: TimeRangeType.actual_type.id,
             start_time: start_time,
             end_time: end_time,
             value: value)
    end

    context 'within filter time range' do
      describe 'average_weekly_actual' do
        context 'with 60 minutes per week' do
          let(:start_time) { Time.zone.local(2019, 11, 10) }
          let(:end_time) { Time.zone.local(2020, 11, 9).end_of_day }
          let(:value) { 3137.1428571428573 }

          it { expect(subject.average_weekly_actual).to eq 60.0 }
        end
      end
    end
  end
end
