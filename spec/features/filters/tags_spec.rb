describe 'filters tags logic', js: true do
  let(:user) { create :user }
  let(:user_group) { create :user_group }

  let!(:membership) { create :membership, :lead, user_group: user_group, user: user }

  let(:tag_type1) { create :tag_type, active_for_activities_at: nil, active_for_time_ranges_at: 1.year.ago }
  let(:tag_type2) { create :tag_type, active_for_activities_at: nil, active_for_time_ranges_at: 1.year.ago }
  let(:tag_type3) { create :tag_type, active_for_activities_at: 1.year.ago, active_for_time_ranges_at: nil }

  let!(:tag1a) { create :tag, tag_type: tag_type1 }
  let!(:tag1b) { create :tag, tag_type: tag_type1 }
  let!(:tag1c) { create :tag, tag_type: tag_type1 }

  let!(:tag2a) { create :tag, tag_type: tag_type2 }
  let!(:tag2b) { create :tag, tag_type: tag_type2 }
  let!(:tag2c) { create :tag, tag_type: tag_type2 }
  let!(:tag2d) { create :tag, tag_type: tag_type2 }

  let!(:tag3a) { create :tag, tag_type: tag_type3 }
  let!(:tag3b) { create :tag, tag_type: tag_type3 }

  let(:plan_start_date) { 11.months.ago.beginning_of_month.to_date }
  let(:plan_end_date) { Date.current.end_of_month.to_date }

  let(:actual_id) { TimeRangeType.actual_type.id }

  let!(:plan) { create :plan, user_id: user.id, start_date: plan_start_date, end_date: plan_end_date }

  let!(:activity1) { create :activity, plan_id: plan.id, seconds_per_week: 7 * 3600, tags: [tag1c, tag2b, tag3a] } # 7h
  let!(:activity2) { create :activity, plan_id: plan.id, seconds_per_week: 5 * 3600, tags: [tag1a, tag3b] } # 5h

  let(:time_range1_start_date) { plan_start_date + 1.week }
  let!(:time_range1) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range1_start_date.beginning_of_day, end_time: time_range1_start_date.end_of_day,
                        value: 300, tags: [tag1c, tag2b]
    # 5h, matches tag filters for actual
  end

  let(:time_range2_start_date) { plan_start_date + 2.weeks }
  let!(:time_range2) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range2_start_date.beginning_of_day, end_time: time_range2_start_date.end_of_day,
                        value: 400, tags: [tag1c, tag2a, tag2d] # 6h 40m, matches tag filters for actual
  end

  let(:time_range3_start_date) { plan_start_date + 3.weeks }
  let!(:time_range3) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range3_start_date.beginning_of_day, end_time: time_range3_start_date.end_of_day,
                        value: 720, tags: [tag1b, tag2a] # 12h, does not match tag filters for actual nor planned
  end

  let(:time_range4_start_date) { plan_start_date + 4.weeks }
  let!(:time_range4) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range4_start_date.beginning_of_day, end_time: time_range4_start_date.end_of_day,
                        value: 200, tags: [tag1c] # 3h 20m, does not match filters for actual
  end

  let(:time_range5_start_date) { plan_start_date + 5.weeks }
  let!(:time_range5) do
    create :time_range, user_id: create(:user).id, time_range_type_id: actual_id,
                        start_time: time_range5_start_date.beginning_of_day, end_time: time_range5_start_date.end_of_day,
                        value: 75, tags: [tag1c, tag2a] # 1h 15m, matches tag filters for actual but belongs to other user
  end

  let(:time_range6_start_date) { plan_start_date + 6.weeks }
  let!(:time_range6) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range6_start_date.beginning_of_day, end_time: time_range6_start_date.end_of_day,
                        value: 360, tags: [tag1b, tag2c] # 6h, does not match tag filters for actual
  end

  let(:time_range7_start_date) { plan_start_date + 7.weeks }
  let!(:time_range7) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range7_start_date.beginning_of_day, end_time: time_range7_start_date.end_of_day,
                        value: 130, tags: [tag2a] # 2h 10m, does not match tag filters for actual, has only one matching
  end

  before do
    log_in user
    visit data_team_individual_path(user_group, user)
  end

  context 'no tag filters applied' do
    it 'shows planned times' do
      within '#team-individual-table' do
        # first week of the plan
        within "tr[data-week-start-date = '#{plan_start_date.beginning_of_week}']" do
          within '.team-individual-table-planned-minutes' do
            expect(page).to have_content '8h 34m'
          end
        end

        # last week of the plan
        within "tr[data-week-start-date = '#{plan_end_date.beginning_of_week}']" do
          within '.team-individual-table-planned-minutes' do
            expect(page).to have_content '5h 9m'
          end
        end

        weeks_count = (plan_end_date.beginning_of_week.to_time - plan_start_date.beginning_of_week.to_time).seconds.in_weeks.to_i

        (weeks_count - 2).times do |n|
          start_date = plan_start_date.beginning_of_week + (n + 1).weeks
          within "tr[data-week-start-date = '#{start_date}']" do
            within '.team-individual-table-planned-minutes' do
              expect(page).to have_content '12h'
            end
          end
        end
      end
    end

    it 'shows actual times' do
      within '#team-individual-table' do
        # first week of the plan
        within "tr[data-week-start-date = '#{plan_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '0h'
          end
        end

        within "tr[data-week-start-date = '#{time_range1_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '5h' # check
          end
        end

        within "tr[data-week-start-date = '#{time_range2_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '6h 40m'
          end
        end

        within "tr[data-week-start-date = '#{time_range3_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '12h'
          end
        end

        within "tr[data-week-start-date = '#{time_range4_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '3h 20m'
          end
        end

        within "tr[data-week-start-date = '#{time_range5_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '0h'
          end
        end

        within "tr[data-week-start-date = '#{time_range6_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '6h'
          end
        end

        within "tr[data-week-start-date = '#{time_range7_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '2h 10m'
          end
        end

        # last week of the plan
        within "tr[data-week-start-date = '#{plan_end_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '0h'
          end
        end
      end
    end
  end

  context 'filter by tag type active for activities' do
    before do
      within '#filters-form' do
        select2 tag3b.name, from: 'Tags'

        click_button 'Filter'
      end
    end

    it 'applies filters for planned times' do
      within '#team-individual-table' do
        [time_range1_start_date, time_range2_start_date, time_range3_start_date, time_range4_start_date,
         time_range5_start_date, time_range6_start_date, time_range7_start_date].each do |start_date|
          within "tr[data-week-start-date = '#{start_date.beginning_of_week}']" do
            within '.team-individual-table-planned-minutes' do
              expect(page).to have_content '5h'
            end
          end
        end
      end
    end

    it 'does not apply for actual times' do
      within '#team-individual-table' do
        within "tr[data-week-start-date = '#{time_range1_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '5h'
          end
        end

        within "tr[data-week-start-date = '#{time_range2_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '6h 40m'
          end
        end

        within "tr[data-week-start-date = '#{time_range3_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '12h'
          end
        end

        within "tr[data-week-start-date = '#{time_range4_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '3h 20m'
          end
        end

        within "tr[data-week-start-date = '#{time_range5_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '0h'
          end
        end

        within "tr[data-week-start-date = '#{time_range6_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '6h'
          end
        end
        page.save_screenshot
        pp time_range7_start_date.beginning_of_week
        pp time_range7_start_date.beginning_of_week.to_s(:db)

        within "tr[data-week-start-date = '#{time_range7_start_date.beginning_of_week}']" do
          within '.team-individual-table-actual-minutes' do
            expect(page).to have_content '2h 10m'
          end
        end
      end
    end
  end

  # logic operator between tag types is AND and between tags within give tag type scope is OR
  it "filters by tags and show respective activities' times" do
    within '#filters-form' do
      select2 tag1c.name, from: 'Tags'
      select2 tag2a.name, from: 'Tags'
      select2 tag2b.name, from: 'Tags'

      click_button 'Filter'
    end

    within '#team-individual-table' do
      within "tr[data-week-start-date = '#{time_range1_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '5h'
        end
      end

      within "tr[data-week-start-date = '#{time_range2_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '6h 40m'
        end
      end

      within "tr[data-week-start-date = '#{time_range3_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end
      end

      within "tr[data-week-start-date = '#{time_range4_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end
      end

      within "tr[data-week-start-date = '#{time_range5_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end
      end

      within "tr[data-week-start-date = '#{time_range6_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end
      end

      within "tr[data-week-start-date = '#{time_range7_start_date.beginning_of_week}']" do
        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end
      end
    end
  end
end
