require 'rails_helper'

describe 'Team Individuals', type: :feature, js: true do
  let(:actual_id) { TimeRangeType.actual_type.id }
  let(:manager) { create(:user, first_name: 'John', last_name: 'Smith', email: 'john@example.com') }
  let!(:user_group) { create(:user_group) }
  let!(:lead_membership) { create(:membership, user_group: user_group, user: manager, role: 'lead') }

  before :each do
    users.each do |user|
      create(
        :plan,
        user_id: user.id,
        start_date: (Time.zone.now - 1.week + 1.day).beginning_of_day,
        end_date: Time.zone.now.end_of_day,
        activities: [create(:activity)] # 240 minutes in 1 week.
      )
      create(
        :time_range,
        user_id: user.id,
        time_range_type_id: actual_id,
        start_time: (Time.zone.now - 1.week + 1.day).beginning_of_day,
        end_time: Time.zone.now.end_of_day,
        value: 120 # 120 minutes in 1 week.
      )
      create(:membership, user_group: user_group, user: user) unless user == manager
    end
    log_in manager
    visit individuals_team_path(user_group)
  end

  context 'with 1 user' do
    let(:users) { [manager] }
    let(:user) { manager }

    it 'has table with planned and actual data' do
      expect(page).to have_text 'Percentage delivered against job plan'
      within('.table') do
        expect(page).to have_text Plan.human_attribute_name('name')
        expect(page).to have_text '5 minutes' # 240 minutes / 52 weeks.
        expect(page).to have_text TimeRangeType.actual_type.name
        expect(page).to have_text '2 minutes' # 120 minutes / 52 weeks.
        expect(page).to have_text 'Percentage delivered'
        expect(page).to have_text '50.0%'
        expect(page).to have_text 'Status'
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
            end_date: Time.zone.now,
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
            expect(page).to have_text 'Really Under'
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
          expect(page).to have_text Plan.human_attribute_name('name')
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
