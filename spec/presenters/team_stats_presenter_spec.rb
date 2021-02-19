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
      time_scope: time_scope,
      graph_kind: graph_kind,
      filter_start_date: filter_start_date,
      filter_end_date: filter_end_date,
      filter_tag_ids: filter_tag_ids }
  end

  let(:a_year_ago) { Time.zone.local(2019, 6, 26, 14, 31, 12) }
  let(:one_month_ago) { Time.zone.local(2020, 5, 26, 14, 31, 12) }
  let(:two_months_ago) { Time.zone.local(2020, 4, 26, 14, 31, 12) }
  let(:now) { Time.zone.local(2020, 6, 26, 14, 31, 12) }

  let(:users) { create_list(:user, 10) }

  let(:filter_start_date) { Time.zone.today - 1.year }
  let(:filter_end_date) { Time.zone.today }
  let(:filter_tag_ids) { [tag1, tag2, tag3].map(&:id) }

  let(:tag1) { create(:tag) }
  let(:tag2) { create(:tag) }
  let(:tag3) { create(:tag) }

  let(:graph_kind) { 'planned_vs_actual' }

  context 'monthly' do
    let(:time_scope) { 'monthly' }

    context 'when users have no time range values' do
      describe 'average_weekly_planned_per_month' do
        it "returns 0s for all row' values" do
          expect(subject.average_weekly_planned_per_month.pluck(:value).uniq).to eq [0]
        end
      end

      describe 'average_weekly_actual_per_month' do
        it "returns 0s for all row' values" do
          expect(subject.average_weekly_actual_per_month.pluck(:value).uniq).to eq [0]
        end
      end

      describe 'weekly_percentage_delivered_per_month' do
        let(:graph_kind) { 'percentage_delivered' }

        it "returns 0s for all row' values" do
          expect(subject.weekly_percentage_delivered_per_month.pluck(:value).uniq).to eq [0]
        end
      end

      describe 'average_weekly_percentage_delivered_per_month' do
        it 'returns zero' do
          expect(subject.average_weekly_percentage_delivered_per_month).to eql 0
        end
      end
    end

    let(:tag_ids) { [tag1.id, tag2.id] }

    context 'when users have plans and actuals' do
      let!(:planned_activity) do
        users.each do |user|
          create(:plan,
                 user_id: user.id,
                 start_date: plan_start_date,
                 end_date: plan_end_date,
                 activities: [
                   create(:activity, tag_ids: tag_ids)
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
                 tag_ids: tag_ids,
                 value: 6240)
        end
      end

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

            it "returns 0s for all row' values" do
              expect(subject.average_weekly_planned_per_month.pluck(:value).uniq).to eq [0]
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

            it "returns 0s for all row' values" do
              expect(subject.average_weekly_actual_per_month.pluck(:value).uniq).to eq [0]
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

        describe 'members_under_delivered_percent' do
          let!(:last_user_long_activity) do
            create(:time_range,
                   user_id: users.last.id,
                   time_range_type_id: TimeRangeType.actual_type.id,
                   start_time: 4.days.ago.beginning_of_day,
                   end_time: 1.day.ago.end_of_day,
                   value: 4 * 24 * 60)
          end

          it 'returns number of users' do
            expect(subject.members_under_delivered_percent).to eql(users.count - 1)
          end
        end
      end
    end
  end

  context 'weekly' do
    let(:time_scope) { 'weekly' }

    let(:plan_start_date) { two_months_ago.to_date } # Sun
    let(:plan_end_date) { now.to_date } # Fri

    let(:filter_start_date) { two_months_ago.to_date }
    let(:filter_end_date) { now.to_date }

    let(:filter_tag_ids) { [tag1, tag2, tag3].map(&:id) }

    context 'when users have plans and actuals' do
      let(:tag_ids) { [tag1.id, tag2.id] }

      let(:actual1_start_time) { two_months_ago.to_date + 9.hours }
      let(:actual1_end_time) { actual1_start_time.to_date + 17.hours }

      let(:actual2_start_time) { (two_months_ago + 1.week).to_date + 9.hours }
      let(:actual2_end_time) { actual2_start_time.to_date + 17.hours }

      let(:actual3_start_time) { one_month_ago.to_date + 8.hours }
      let(:actual3_end_time) { actual3_start_time.to_date + 16.hours }

      let(:actual4_start_time) { now.beginning_of_week.to_date + 12.hours }
      let(:actual4_end_time) { actual4_start_time.to_date + 20.hours }

      let!(:planned_activities) do
        users.each do |user|
          create(:plan,
                 user_id: user.id,
                 start_date: plan_start_date,
                 end_date: plan_end_date,
                 activities: [
                   create(
                     :activity,
                     seconds_per_week: 8 * 3600, # 8h
                     tag_ids: tag_ids
                   )
                 ])
        end
      end

      let!(:actual_activity) do
        users.each do |user|
          create(:time_range,
                 user_id: user.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: actual1_start_time,
                 end_time: actual1_end_time,
                 tag_ids: tag_ids.sample,
                 value: 8 * 60) # 8h

          create(:time_range,
                 user_id: user.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: actual2_start_time,
                 end_time: actual2_end_time,
                 tag_ids: tag_ids.sample,
                 value: 8 * 60) # 8h
        end

        users.first(5).each do |user|
          create(:time_range,
                 user_id: user.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: actual3_start_time,
                 end_time: actual3_end_time,
                 tag_ids: tag_ids.sample,
                 value: 4.5 * 60) # 4.5h
        end
        users.last(5).each do |user|
          create(:time_range,
                 user_id: user.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: actual3_start_time,
                 end_time: actual3_end_time,
                 tag_ids: tag_ids.sample,
                 value: 6.5 * 60) # 6.5h
        end

        users.each do |user|
          create(:time_range,
                 user_id: user.id,
                 time_range_type_id: TimeRangeType.actual_type.id,
                 start_time: actual4_start_time,
                 end_time: actual4_end_time,
                 tag_ids: tag_ids.sample,
                 value: 9 * 60) # 9h
        end
      end

      context 'within filter time range' do
        describe 'average_weekly_planned_per_week' do
          it 'returns average weekly planned values for the time range' do
            # Approx 4 hours per week * 10 users = approx 2400 minutes per week.
            # 4800 because there is one 8h long activity in the plan
            expect(subject.average_weekly_planned_per_week).to eq(
              [
                { 'name': '2020-04-20T00:00:00.000Z', 'value': 685.7, 'notes': '[]' },
                # 4800/7 * 1 because filter range starts on Sun, so only one day from the week counted
                { 'name': '2020-04-27T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-05-04T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-05-11T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-05-18T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-05-25T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-06-01T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-06-08T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-06-15T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-06-22T00:00:00.000Z', 'value': 3428.6, 'notes': '[]' }
                # 4800/7 * 5 because filter range ends on Fri so only 5 days from the week counted
              ]
            )
          end

          context 'when tag not included' do
            let(:filter_tag_ids) { nil }

            it "returns 0s for all row' values" do
              expect(subject.average_weekly_planned_per_week.pluck(:value).uniq).to eq [0]
            end
          end
        end

        describe 'average_weekly_actual_per_week' do
          it 'returns average weekly actual values for the time range' do
            expect(subject.average_weekly_actual_per_week).to eq(
              [
                { 'name': '2020-04-20T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-04-27T00:00:00.000Z', 'value': 4800.0, 'notes': '[]' },
                { 'name': '2020-05-04T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-11T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-18T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-25T00:00:00.000Z', 'value': 3300.0, 'notes': '[]' }, # 4.5h + 6.5.h / 2 = 5.5h p/u * 10 = 3300
                { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-08T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-15T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-22T00:00:00.000Z', 'value': 5400.0, 'notes': '[]' }
              ]
            )
          end

          context 'when tag not included' do
            let(:filter_tag_ids) { nil }

            it "returns 0s for all row' values" do
              expect(subject.average_weekly_actual_per_month.pluck(:value).uniq).to eq [0]
            end
          end
        end

        describe 'weekly_percentage_delivered_per_week' do
          it 'returns the percentage delivered over the time range, with any notes' do
            expect(subject.weekly_percentage_delivered_per_week).to eq(
              [
                { 'name': '2020-04-20T00:00:00.000Z', 'value': 700.01, 'notes': '[]' },
                { 'name': '2020-04-27T00:00:00.000Z', 'value': 100, 'notes': '[]' },
                { 'name': '2020-05-04T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-11T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-18T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-05-25T00:00:00.000Z', 'value': 68.75, 'notes': '[]' },
                { 'name': '2020-06-01T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-08T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-15T00:00:00.000Z', 'value': 0, 'notes': '[]' },
                { 'name': '2020-06-22T00:00:00.000Z', 'value': 157.5, 'notes': '[]' }
              ]
            )
          end

          describe 'one week has notes' do
            let!(:n1) { create :note, start_time: DateTime.new(2020, 5, 19) }
            let!(:n2) { create :note, start_time: DateTime.new(2020, 5, 20) }

            it 'contains row with serialized notes' do
              expect(subject.weekly_percentage_delivered_per_week[3][:notes]).to eql '[]'
              expect(subject.weekly_percentage_delivered_per_week[4][:notes]).to eql [n1, n2].map(&:with_author).to_json
              expect(subject.weekly_percentage_delivered_per_week[5][:notes]).to eql '[]'
            end
          end
        end

        describe 'average_weekly_percentage_delivered_per_week' do
          it 'returns average' do
            expect(subject.average_weekly_percentage_delivered_per_week).to eql 103
          end
        end

        describe 'members_under_delivered_percent' do
          let!(:last_user_all_day_activity) do
            create(:time_range,
                   user_id: users.last.id,
                   time_range_type_id: TimeRangeType.actual_type.id,
                   start_time: 1.day.ago.beginning_of_day,
                   end_time: 1.day.ago.end_of_day,
                   value: 24 * 60)
          end

          it 'returns number of users' do
            expect(subject.members_under_delivered_percent).to eql(users.count - 1)
          end
        end
      end
    end
  end
end
