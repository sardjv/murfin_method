require 'rails_helper'

describe 'Team Individual Data', type: :feature, js: true, freeze: Time.zone.local(2021, 2, 28, 15, 30, 0o0) do
  let(:actual_id) { TimeRangeType.actual_type.id }

  let(:manager) { create :user }
  let(:user) { create :user }

  let(:user_group) { create :user_group }

  let!(:lead_membership) { create :membership, user_group: user_group, user: manager, role: 'lead' }
  let!(:user_membership) { create :membership, user_group: user_group, user: user, role: 'member' }

  let(:plan_start_date) { 1.year.ago.beginning_of_month }
  let(:plan_end_date) { plan_start_date.end_of_month }
  let!(:plan) do
    create :plan, user_id: user.id,
                  start_date: plan_start_date, end_date: plan_end_date,
                  activities: [create(:activity)] # 4h per week.
  end

  let(:time_range1_start_date) { plan_start_date }
  let!(:time_range1) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range1_start_date.beginning_of_day, end_time: time_range1_start_date.end_of_day,
                        value: 120 # 2h in first week
  end

  let(:time_range2_start_date) { plan_start_date + 1.week }
  let!(:time_range2) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range2_start_date.beginning_of_day, end_time: time_range2_start_date.end_of_day,
                        value: 270 # 4,5h in second week
  end

  before do
    log_in manager
    visit team_individual_path(user_group, user)

    within '.nav-tabs' do
      click_link 'Data'
    end
  end

  it { expect(current_path).to eql data_team_individual_path(user_group, user) }

  it 'shows boxes with stats' do
    within '#team-individual-box-average-planned-per-week' do
      expect(page).to have_content '18m'
      expect(page).to have_content 'Average planned per week'
    end

    within '#team-individual-box-average-actual-per-week' do
      expect(page).to have_content '7m'
      expect(page).to have_content 'Average actual per week'
    end

    within '#team-individual-box-average-percentage-per-week' do
      expect(page).to have_content '39%'
      expect(page).to have_content 'Average percentage per week'
    end
  end

  it 'contains user group name' do
    within '#team-individual-user-groups' do
      expect(page).to have_content user_group.name
    end
  end

  it 'shows table with stats groupped weekly' do
    within '.table-responsive' do
      within "tr[data-week-start-date='2020-01-27']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Jan 27th - Feb 2nd'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '1h 9m'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '2h'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '175%'
        end
      end

      within "tr[data-week-start-date='2020-02-03']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Feb 3rd - 9th'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '4h'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '4h 30m'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '113%'
        end
      end

      within "tr[data-week-start-date='2020-02-10']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Feb 10th - 16th'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '4h'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '0%'
        end
      end

      within "tr[data-week-start-date='2020-02-24']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Feb 24th - Mar 1st'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '3h 26m'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0h'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '0%'
        end
      end
    end
  end
end
