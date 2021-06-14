require 'rails_helper'

describe 'Team Individuals', type: :feature, js: true, freeze: Time.zone.local(2021, 2, 16, 17, 59, 59) do
  let(:actual_id) { TimeRangeType.actual_type.id }

  let(:admin) { create :admin }
  let(:manager) { create :user }
  let!(:user_group) { create(:user_group) }
  let!(:lead_membership) { create :membership, user_group: user_group, user: manager, role: 'lead' }

  before do
    users.each do |user|
      create(
        :plan,
        user_id: user.id,
        start_date: 6.days.ago.beginning_of_day,
        end_date: Time.current.end_of_day,
        activities: [create(:activity)] # 240 minutes in 1 week.
      )
      create(
        :time_range,
        user_id: user.id,
        time_range_type_id: actual_id,
        start_time: 6.days.ago.beginning_of_day,
        end_time: 6.days.ago.end_of_day,
        value: 120 # 120 minutes in 1 week.
      )
      create(:membership, user_group: user_group, user: user) unless user == manager
    end

    log_in admin
    visit dashboard_admin_team_path(user_group)

    within '.thin-tabs' do
      click_link 'Individuals'
    end
  end

  context 'with 1 user' do
    let(:users) { [manager] }
    let(:user) { manager }

    it 'has table with planned and actual data' do
      expect(page).to have_text 'Percentage delivered against job plan'

      within '.table' do
        within 'thead' do
          expect(page).to have_text 'Plan'
          expect(page).to have_text 'Average planned per week'
          expect(page).to have_text 'Average actual per week'
          expect(page).to have_text 'Average percentage per week'
          expect(page).to have_text 'Status'
        end

        expect(page).to have_text user.name
        expect(page).to have_text '5 minutes'
        expect(page).to have_text '2 minutes'
        expect(page).to have_text '50%'
        expect(page).to have_text 'Under'
      end
    end

    describe 'caching' do
      context 'when actuals are updated' do
        before do
          user.time_ranges.each { |tr| tr.update(value: 0) }
          visit current_path
        end

        it 'updates the values' do
          within('.table') do
            expect(page).to have_text 'Really Under'
          end
        end
      end

      context 'when another plan is created' do
        before do
          create(
            :plan,
            user_id: user.id,
            start_date: 1.week.ago,
            end_date: Time.current,
            activities: [create(:activity)] # 240 minutes in 1 week.
          )
          visit current_path
        end

        it 'updates the values' do
          within('.table') do
            expect(page).to have_text 'Really Under'
          end
        end
      end

      context 'when a plan is updated' do
        before do
          Activity.first.plan.update(start_date: 2.years.ago, end_date: 2.years.ago + 1.week)
          visit current_path
        end

        it 'updates the values' do
          within('.table') do
            expect(page).to have_text 'Unknown'
          end
        end
      end

      context 'when a plan is deleted' do
        before do
          Activity.first.plan.destroy
          visit current_path
        end

        it 'updates the values' do
          within('.table') do
            expect(page).to have_text 'Unknown'
          end
        end
      end

      context 'when an activity is updated' do
        before do
          Activity.first.update(seconds_per_week: 12 * 60 * 60)
          visit current_path
        end

        it 'updates the values' do
          within('.table') do
            expect(page).to have_text 'Under'
          end
        end
      end
    end
  end

  context 'with 11 users' do
    let(:users) { create_list(:user, 11) }

    describe 'pagination' do
      it 'puts user #11 on the next page' do
        within('.table') do
          expect(page).not_to have_text users.last.name
        end
        click_on 'Next'

        within('.table') do
          expect(page).to have_text users.last.name
        end
      end
    end
  end
end
