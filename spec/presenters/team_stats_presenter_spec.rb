describe TeamStatsPresenter do
  subject { TeamStatsPresenter.new(args) }

  before :all do
    Timecop.freeze(Time.zone.local(2020, 6, 26, 14))
  end

  after :all do
    Timecop.return
  end

  let(:args) do
    { users: users,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date }
  end

  let(:users) { create_list(:user, 10) }
  let(:filter_start_date) { Time.zone.today - 1.year }
  let(:filter_end_date) { Time.zone.today }

  context 'when users have no time range values' do
    describe 'average_weekly_planned_per_month' do
      it 'returns 0 per month' do
        expect(subject.average_weekly_planned_per_month).to eq(
          [
            { 'name': 'June', 'value': 0 },
            { 'name': 'July', 'value': 0 },
            { 'name': 'August', 'value': 0 },
            { 'name': 'September', 'value': 0 },
            { 'name': 'October', 'value': 0 },
            { 'name': 'November', 'value': 0 },
            { 'name': 'December', 'value': 0 },
            { 'name': 'January', 'value': 0 },
            { 'name': 'February', 'value': 0 },
            { 'name': 'March', 'value': 0 },
            { 'name': 'April', 'value': 0 },
            { 'name': 'May', 'value': 0 },
            { 'name': 'June', 'value': 0 }
          ]
        )
      end
    end

    describe 'average_weekly_actual_per_month' do
      it 'returns 0 per month' do
        expect(subject.average_weekly_actual_per_month).to eq(
          [
            { 'name': 'June', 'value': 0 },
            { 'name': 'July', 'value': 0 },
            { 'name': 'August', 'value': 0 },
            { 'name': 'September', 'value': 0 },
            { 'name': 'October', 'value': 0 },
            { 'name': 'November', 'value': 0 },
            { 'name': 'December', 'value': 0 },
            { 'name': 'January', 'value': 0 },
            { 'name': 'February', 'value': 0 },
            { 'name': 'March', 'value': 0 },
            { 'name': 'April', 'value': 0 },
            { 'name': 'May', 'value': 0 },
            { 'name': 'June', 'value': 0 }
          ]
        )
      end
    end

    describe 'weekly_percentage_delivered_per_month' do
      it 'returns 0 per month' do
        expect(subject.weekly_percentage_delivered_per_month).to eq(
          [
            { 'name': 'June', 'value': 0 },
            { 'name': 'July', 'value': 0 },
            { 'name': 'August', 'value': 0 },
            { 'name': 'September', 'value': 0 },
            { 'name': 'October', 'value': 0 },
            { 'name': 'November', 'value': 0 },
            { 'name': 'December', 'value': 0 },
            { 'name': 'January', 'value': 0 },
            { 'name': 'February', 'value': 0 },
            { 'name': 'March', 'value': 0 },
            { 'name': 'April', 'value': 0 },
            { 'name': 'May', 'value': 0 },
            { 'name': 'June', 'value': 0 }
          ]
        )
      end
    end
  end

  context 'when users hav time range values' do
    let!(:planned_activity) do
      users.each do |user|
        create(:time_range,
               user_id: user.id,
               time_range_type_id: TimeRangeType.plan_type.id,
               start_time: plan_start_time,
               end_time: plan_end_time,
               value: 1500)
      end
    end
    let!(:actual_activity) do
      users.each do |user|
        create(:time_range,
               user_id: user.id,
               time_range_type_id: TimeRangeType.actual_type.id,
               start_time: actual_start_time,
               end_time: actual_end_time,
               value: 630)
      end
    end

    let(:a_year_ago) { Time.zone.local(2019, 6, 26, 14, 31, 12) }
    let(:now) { Time.zone.local(2020, 6, 26, 14, 31, 12) }

    let(:plan_start_time) { a_year_ago }
    let(:plan_end_time) { now }
    let(:actual_start_time) { a_year_ago }
    let(:actual_end_time) { now }

    context 'within filter time range' do
      describe 'average_weekly_planned_per_month' do
        it 'returns average weekly planned values for the time range' do
          # Approx 1500 (value per user for year) * 10 users / 52 weeks = 288.46.
          expect(subject.average_weekly_planned_per_month).to eq(
            [
              { 'name': 'June', 'value': 42 },
              { 'name': 'July', 'value': 287 },
              { 'name': 'August', 'value': 287 },
              { 'name': 'September', 'value': 287 },
              { 'name': 'October', 'value': 287 },
              { 'name': 'November', 'value': 287 },
              { 'name': 'December', 'value': 287 },
              { 'name': 'January', 'value': 287 },
              { 'name': 'February', 'value': 287 },
              { 'name': 'March', 'value': 287 },
              { 'name': 'April', 'value': 287 },
              { 'name': 'May', 'value': 287 },
              { 'name': 'June', 'value': 245 }
            ]
          )
        end
      end

      describe 'average_weekly_actual_per_month' do
        it 'returns average weekly actual values for the time range' do
          # Approx 630 (value per user for year) * 10 users / 52 weeks = 121.15.
          expect(subject.average_weekly_actual_per_month).to eq(
            [
              { 'name': 'June', 'value': 18 },
              { 'name': 'July', 'value': 120 },
              { 'name': 'August', 'value': 120 },
              { 'name': 'September', 'value': 120 },
              { 'name': 'October', 'value': 120 },
              { 'name': 'November', 'value': 120 },
              { 'name': 'December', 'value': 120 },
              { 'name': 'January', 'value': 120 },
              { 'name': 'February', 'value': 120 },
              { 'name': 'March', 'value': 120 },
              { 'name': 'April', 'value': 120 },
              { 'name': 'May', 'value': 120 },
              { 'name': 'June', 'value': 103 }
            ]
          )
        end
      end

      describe 'weekly_percentage_delivered_per_month' do
        it 'returns the percentage delivered over the time range' do
          # Approx 630/1500 == 0.42.
          expect(subject.weekly_percentage_delivered_per_month).to eq(
            [
              { 'name': 'June', 'value': 42.86 },
              { 'name': 'July', 'value': 41.81 },
              { 'name': 'August', 'value': 41.81 },
              { 'name': 'September', 'value': 41.81 },
              { 'name': 'October', 'value': 41.81 },
              { 'name': 'November', 'value': 41.81 },
              { 'name': 'December', 'value': 41.81 },
              { 'name': 'January', 'value': 41.81 },
              { 'name': 'February', 'value': 41.81 },
              { 'name': 'March', 'value': 41.81 },
              { 'name': 'April', 'value': 41.81 },
              { 'name': 'May', 'value': 41.81 },
              { 'name': 'June', 'value': 42.04 }
            ]
          )
        end
      end
    end
  end
end
