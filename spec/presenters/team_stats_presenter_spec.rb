describe TeamStatsPresenter do
  subject { TeamStatsPresenter.new(args) }

  before :all do
    Timecop.freeze(Time.zone.local(2020, 6, 26, 14, 59, 59))
  end

  after :all do
    Timecop.return
  end

  let(:args) do
    { user_ids: users.pluck(:id),
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids }
  end

  let(:users) { create_list(:user, 10) }
  let(:filter_start_date) { Time.zone.today - 1.year }
  let(:filter_end_date) { Time.zone.today }
  let(:filter_tag_ids) { [tag1, tag2, tag3].map(&:id) }
  let(:tag1) { create(:tag) }
  let(:tag2) { create(:tag) }
  let(:tag3) { create(:tag) }

  context 'when users have no time range values' do
    describe 'average_weekly_planned_per_month' do
      it 'returns 0 per month' do
        expect(subject.average_weekly_planned_per_month).to eq(
          [
            { 'name': '2019-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-07-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-08-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-09-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-10-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-11-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-12-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-01-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-02-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-03-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-04-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-05-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' }
          ]
        )
      end
    end

    describe 'average_weekly_actual_per_month' do
      it 'returns 0 per month' do
        expect(subject.average_weekly_actual_per_month).to eq(
          [
            { 'name': '2019-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-07-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-08-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-09-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-10-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-11-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-12-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-01-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-02-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-03-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-04-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-05-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' }
          ]
        )
      end
    end

    describe 'weekly_percentage_delivered_per_month' do
      it 'returns 0 per month' do
        expect(subject.weekly_percentage_delivered_per_month).to eq(
          [
            { 'name': '2019-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-07-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-08-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-09-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-10-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-11-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2019-12-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-01-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-02-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-03-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-04-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-05-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
            { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' }
          ]
        )
      end
    end

    describe 'average_weekly_percentage_delivered_per_month' do
      it 'returns zero' do
        expect(subject.average_weekly_percentage_delivered_per_month).to eql 0
      end
    end
  end

  context 'when users have plans and actuals' do
    let!(:planned_activity) do
      users.each do |user|
        create(:plan,
               user_id: user.id,
               start_date: plan_start_date,
               end_date: plan_end_date,
               activities: [
                 create(
                   :activity,
                   tag_associations: [
                     build(:tag_association, tag: tag1, tag_type: tag1.tag_type),
                     build(:tag_association, tag: tag2, tag_type: tag2.tag_type)
                   ]
                 )
               ])
      end
    end
    let!(:actual_activity) do
      users.each do |user|
        create(:time_range,
               user_id: user.id,
               time_range_type_id: TimeRangeType.actual_type.id,
               start_time: actual_start_time,
               end_time: actual_end_time,
               tag_associations: [
                 build(:tag_association, tag: tag1, tag_type: tag1.tag_type),
                 build(:tag_association, tag: tag3, tag_type: tag3.tag_type)
               ],
               value: 6240)
      end
    end

    let(:a_year_ago) { Time.zone.local(2019, 6, 26, 14, 31, 12) }
    let(:now) { Time.zone.local(2020, 6, 26, 14, 31, 12) }

    let(:plan_start_date) { a_year_ago }
    let(:plan_end_date) { now }
    let(:actual_start_time) { a_year_ago }
    let(:actual_end_time) { now }

    context 'within filter time range' do
      describe 'average_weekly_planned_per_month' do
        it 'returns average weekly planned values for the time range' do
          # Approx 4 hours per week * 10 users = approx 2400 minutes per week.
          expect(subject.average_weekly_planned_per_month).to eq(
            [
              { 'name': '2019-06-01T00:00:00.000Z', 'value': 400, 'notes': '[]' },
              { 'name': '2019-07-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2019-08-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2019-09-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2019-10-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2019-11-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2019-12-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-01-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-02-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-03-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-04-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-05-01T00:00:00.000Z', 'value': 2400, 'notes': '[]' },
              { 'name': '2020-06-01T00:00:00.000Z', 'value': 2080, 'notes': '[]' }
            ]
          )
        end

        context 'when tag not included' do
          let(:filter_tag_ids) { nil }

          it 'returns 0' do
            expect(subject.average_weekly_planned_per_month).to eq(
              [
                { 'name': '2019-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-07-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-08-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-09-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-10-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-11-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-12-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-01-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-02-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-03-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-04-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' }
              ]
            )
          end
        end
      end

      describe 'average_weekly_actual_per_month' do
        it 'returns average weekly actual values for the time range' do
          # 6240 (2 hours per week per user for year) * 10 users / 52 weeks = 1200.
          expect(subject.average_weekly_actual_per_month).to eq(
            [
              { 'name': '2019-06-01T00:00:00.000Z', 'value': 175, 'notes': '[]' },
              { 'name': '2019-07-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2019-08-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2019-09-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2019-10-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2019-11-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2019-12-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-01-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-02-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-03-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-04-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-05-01T00:00:00.000Z', 'value': 1193, 'notes': '[]' },
              { 'name': '2020-06-01T00:00:00.000Z', 'value': 1019, 'notes': '[]' }
            ]
          )
        end

        context 'when tag not included' do
          let(:filter_tag_ids) { nil }

          it 'returns 0' do
            expect(subject.average_weekly_actual_per_month).to eq(
              [
                { 'name': '2019-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-07-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-08-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-09-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-10-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-11-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2019-12-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-01-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-02-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-03-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-04-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' }
              ]
            )
          end
        end
      end

      describe 'weekly_percentage_delivered_per_month' do
        let!(:n1) { create(:note, start_time: DateTime.new(2019, 11, 1)) }
        let!(:n2) { create(:note, start_time: DateTime.new(2019, 11, 14)) }

        it 'returns the percentage delivered over the time range, with any notes' do
          # Approx 6240/12480 == 0.5.
          expect(subject.weekly_percentage_delivered_per_month).to eq(
            [
              { 'name': '2019-06-01T00:00:00.000Z', 'value': 43.75, 'notes': '[]' },
              { 'name': '2019-07-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2019-08-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2019-09-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2019-10-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2019-11-01T00:00:00.000Z', 'value': 49.71, 'notes': [n1, n2].map(&:with_author).to_json },
              { 'name': '2019-12-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-01-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-02-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-03-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-04-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-05-01T00:00:00.000Z', 'value': 49.71, 'notes': '[]' },
              { 'name': '2020-06-01T00:00:00.000Z', 'value': 48.99, 'notes': '[]' }
            ]
          )
        end

        context 'without actuals' do
          let!(:actual_activity) { nil }
          it { expect { subject.weekly_percentage_delivered_per_month }.not_to raise_error }
        end
      end

      describe 'average_weekly_percentage_delivered_per_month' do
        it 'returns average' do
          expect(subject.average_weekly_percentage_delivered_per_month).to eql 49
        end
      end

      describe 'people_under_80_percent_delivered' do
        let!(:last_user_long_activity) do
          create(:time_range,
                 user_id: users.last.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: 4.days.ago.beginning_of_day,
                 end_time: 1.day.ago.end_of_day,
                 value: 4 * 24 * 60)
        end

        it 'returns number of users' do
          expect(subject.people_under_80_percent_delivered).to eql(users.count - 1)
        end
      end
    end
  end
end
