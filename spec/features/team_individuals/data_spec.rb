require 'rails_helper'

describe 'Team Individual Data', type: :feature, js: true, freeze: Time.zone.local(2021, 2, 28, 15, 30, 0) do
  let(:actual_id) { TimeRangeType.actual_type.id }

  let(:manager) { create :user }
  let(:user) { create :user }

  let(:user_group) { create :user_group }

  let!(:lead_membership) { create :membership, user_group: user_group, user: manager, role: 'lead' }
  let!(:user_membership) { create :membership, user_group: user_group, user: user, role: 'member' }

  let(:plan_start_date) { 11.months.ago.beginning_of_month.to_date }
  let(:plan_end_date) { Date.current.end_of_month.to_date }

  let!(:plan) do
    create :plan, user_id: user.id,
                  start_date: plan_start_date, end_date: plan_end_date,
                  activities: [create(:activity)] # 4h per week.
  end

  let(:time_range1_start_date) { plan_start_date + 1.week }
  let!(:time_range1) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range1_start_date.beginning_of_day, end_time: time_range1_start_date.end_of_day,
                        value: 120 # 2h in second week
  end

  let(:time_range2_start_date) { plan_start_date + 2.weeks }
  let!(:time_range2) do
    create :time_range, user_id: user.id, time_range_type_id: actual_id,
                        start_time: time_range2_start_date.beginning_of_day, end_time: time_range2_start_date.end_of_day,
                        value: 270 # 4,5h in third week
  end

  before do
    log_in manager
    visit data_team_individual_path(user_group, user)
  end

  it 'shows boxes with stats' do
    within '#box-average-planned-per-week' do
      expect(page).to have_content '4h'
      expect(page).to have_content 'Average planned per week'
    end

    within '#box-average-actual-per-week' do
      expect(page).to have_content '8m'
      expect(page).to have_content 'Average actual per week'
    end

    within '#box-average-percentage-per-week' do
      expect(page).to have_content '3%'
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
      within "tr[data-week-start-date='2020-02-24']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Feb 24th - Mar 1st'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '34m'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '0'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '0%'
        end
      end

      within "tr[data-week-start-date='2020-03-02']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Mar 2nd - 8th'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '4h'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '2h'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '50%'
        end
      end

      within "tr[data-week-start-date='2020-03-09']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Mar 9th - 15th'
        end

        within '.team-individual-table-planned-minutes' do
          expect(page).to have_content '4h'
        end

        within '.team-individual-table-actual-minutes' do
          expect(page).to have_content '4h 30m'
        end

        within '.team-individual-table-percentage' do
          expect(page).to have_content '112%'
        end
      end

      within "tr[data-week-start-date='2020-03-16']" do
        within '.team-individual-table-week' do
          expect(page).to have_content 'Mar 16th - 22nd'
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
    end
  end

  describe 'filters' do
    it 'has set default last 12 months range' do
      within '#filters-form' do
        within 'a#filters-predefined-ranges-toggle' do
          expect(page).to have_content 'Last 12 months'
        end
        expect(page).to have_css "input#query_filter_start_date[value = '2020-03-01']", visible: false
        expect(page).to have_css "input#query_filter_end_date[value = '2021-02-28']", visible: false
      end
    end

    describe 'select predefined range' do
      it 'applies range into team individuals table' do
        within '#filters-form' do
          find('#filters-predefined-ranges-toggle').click

          within '#filters-predefined-ranges-menu' do
            click_link 'Last 3 months'
          end

          click_button 'Filter'
        end

        within '#team-individual-table' do
          expect(page).not_to have_content 'Nov 23rd - 29th'

          within first('.team-individual-table-week') do
            expect(page).to have_content 'Nov 30th - Dec 6th'
          end

          within all('.team-individual-table-week').last do
            expect(page).to have_content 'Feb 22nd - 28th'
          end
        end

        # make sure after page refresh Last 3 months option is still selected
        within 'a#filters-predefined-ranges-toggle' do
          expect(page).to have_content 'Last 3 months'
        end

        within '#filters-predefined-ranges-menu', visible: false do
          expect(page).to have_css '.dropdown-item.active', text: 'Last 3 months', visible: false
        end
      end
    end

    describe 'select custom range' do
      it 'applies range into team individuals table' do
        within '#filters-form' do
          find('.filters-start-date-container input').click
        end

        within '.flatpickr-monthSelect-months' do # Jan 2020
          find('.flatpickr-monthSelect-month', text: 'Jan').click
        end

        within '#filters-form' do
          find('.filters-end-date-container input').click
        end

        within '.flatpickr-calendar .flatpickr-months' do
          find('.flatpickr-prev-month').click # it's actually prev year, seems that plugin has wrong class name here
        end

        within '.flatpickr-monthSelect-months' do # Feb 2020
          find('.flatpickr-monthSelect-month', text: 'Feb').click
        end

        within '#filters-form' do # make sure beginning of start month and end of end month is set
          expect(page).to have_css "input#query_filter_start_date[value = '2020-01-01']", visible: false
          expect(page).to have_css "input#query_filter_end_date[value = '2020-02-29']", visible: false
        end

        within 'a#filters-predefined-ranges-toggle' do
          expect(page).to have_content 'Custom'
        end

        within '#filters-predefined-ranges-menu', visible: false do
          expect(page).to have_css '.dropdown-item.active', text: 'Custom', visible: false
        end

        within '#filters-form' do
          click_button 'Filter'
        end

        within '#team-individual-table' do
          expect(page).not_to have_content 'Dec 23th - 29th'
        end

        within '#team-individual-table' do
          find('.team-individual-table-week', text: 'Dec 30th, 2019 - Jan 5th, 2020')

          within first('.team-individual-table-week') do
            expect(page).to have_content 'Dec 30th, 2019 - Jan 5th, 2020'
          end

          within all('.team-individual-table-week').last do
            expect(page).to have_content 'Feb 24th - Mar 1st'
          end
        end

        # make sure after page refresh Custom is still selected
        within 'a#filters-predefined-ranges-toggle' do
          expect(page).to have_content 'Custom'
        end

        within '#filters-predefined-ranges-menu', visible: false do
          expect(page).to have_css '.dropdown-item.active', text: 'Custom', visible: false
        end
      end
    end
  end
end
