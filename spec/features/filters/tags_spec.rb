describe 'filters tags logic', js: true do
  let(:user) { create :user }
  let(:user_group) { create :user_group }

  let!(:membership) { create :membership, :lead, user_group: user_group, user: user }

  let(:tag_type1) { create :tag_type, id: 100 }
  let(:tag_type2) { create :tag_type, id: 200 }
  let(:tag_type3) { create :tag_type, id: 300 }

  let!(:tag1a) { create :tag, tag_type: tag_type1, name: '1a' }
  let!(:tag1b) { create :tag, tag_type: tag_type1, name: '1b' }
  let!(:tag1c) { create :tag, tag_type: tag_type1, name: '1c' }

  let!(:tag2a) { create :tag, tag_type: tag_type2, name: '2a' }
  let!(:tag2b) { create :tag, tag_type: tag_type2, name: '2b' }
  let!(:tag2c) { create :tag, tag_type: tag_type2, name: '2c' }
  let!(:tag2d) { create :tag, tag_type: tag_type2, name: '2d' }

  let!(:tag3a) { create :tag, tag_type: tag_type3, name: '3a' }
  let!(:tag3b) { create :tag, tag_type: tag_type3, name: '3b' }

  let(:start_date) { 11.months.ago.beginning_of_month.to_date }
  let(:end_date) { Date.current.end_of_month.to_date }

  let(:actual_id) { TimeRangeType.actual_type.id }

  let!(:activity) { create :activity, seconds_per_week: 10 * 3600 } # 10h

  let!(:plan) do
    create :plan, user_id: user.id,
                  start_date: start_date, end_date: end_date,
                  activities: [activity]
  end

  let(:time_range1_start_date) { start_date + 1.week }
  let!(:time_range1) do
    create :time_range, id: 111, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range1_start_date.beginning_of_day, end_time: time_range1_start_date.end_of_day,
                        value: 300, tags: [tag1c, tag2b] # 5h, matches tag filters
  end

  let(:time_range2_start_date) { start_date + 2.weeks }
  let!(:time_range2) do
    create :time_range, id: 222, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range2_start_date.beginning_of_day, end_time: time_range2_start_date.end_of_day,
                        value: 400, tags: [tag1c, tag2a, tag2d] # 6h 40m, matches tag filters
  end

  let(:time_range3_start_date) { start_date + 3.weeks }
  let!(:time_range3) do
    create :time_range, id: 333, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range3_start_date.beginning_of_day, end_time: time_range3_start_date.end_of_day,
                        value: 600, tags: [tag1b, tag2a] # 10h, does not match tag filters
  end

  let(:time_range4_start_date) { start_date + 4.weeks }
  let!(:time_range4) do
    create :time_range, id: 444, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range4_start_date.beginning_of_day, end_time: time_range4_start_date.end_of_day,
                        value: 200, tags: [tag1c, tag3a] # 3h 20m, does not tag match filters
  end

  let(:time_range5_start_date) { start_date + 5.weeks }
  let!(:time_range5) do
    create :time_range, id: 555, user_id: create(:user).id, time_range_type_id: actual_id,
                        start_time: time_range5_start_date.beginning_of_day, end_time: time_range5_start_date.end_of_day,
                        value: 75, tags: [tag1c, tag2a] # 1h 15m, matches tag filters but belongs to other user
  end

  let(:time_range6_start_date) { start_date + 6.weeks }
  let!(:time_range6) do
    create :time_range, id: 666, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range6_start_date.beginning_of_day, end_time: time_range6_start_date.end_of_day,
                        value: 360, tags: [tag1c, tag2c] # 6h, does not match tag filters
  end

  let(:time_range7_start_date) { start_date + 7.weeks }
  let!(:time_range7) do
    create :time_range, id: 777, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range7_start_date.beginning_of_day, end_time: time_range7_start_date.end_of_day,
                        value: 130, tags: [tag2a] # 2h 10m, does not match tag filters, has only one matching
  end

  before do
    log_in user
    visit data_team_individual_path(user_group, user)
  end

  context 'no tag filters applied' do
    it "lists all user' activity" do
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
            expect(page).to have_content '10h'
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
      end
    end
  end
  # Cat: DCC, Subcat: family therapy , Rio: DNA
  # logic operator between tag types is AND and between tags within give tag type scope is OR
  it "filters by tags and show respective activities' times" do
    # pp 'time_range4.tags', time_range4.tags
    # pp 'time_range4.tag_types', time_range4.tag_types

    within '#filters-form' do
      select2 tag1c.name, from: 'Tags'
      select2 tag2a.name, from: 'Tags'
      select2 tag2b.name, from: 'Tags'

      click_button 'Filter'
    end

    within '#team-individual-table' do
      page.save_screenshot

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
