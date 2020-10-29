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
        start_date: 1.week.ago,
        end_date: Time.zone.now,
        activities: [create(:activity)] # 240 minutes in 1 week.
      )
      create_list(
        :time_range,
        10,
        user_id: user.id,
        time_range_type_id: actual_id,
        start_time: 1.week.ago,
        end_time: Time.zone.now,
        value: 12 # 12 minutes * 10 = 120 minutes in 1 week.
      )
      create(:membership, user_group: user_group, user: user)
    end
    log_in manager
    visit individuals_team_path(user_group)
  end

  context 'with 1 user' do
    let(:users) { [create(:user)] }
    let(:user) { users.first }

    it 'has table with planned and actual data' do
      expect(page).to have_text 'Percentage delivered against job plan'
      within('.table') do
        expect(page).to have_text 'Job Plan'
        expect(page).to have_text '4 minutes' # 240 minutes / 52 weeks.
        expect(page).to have_text 'RIO Data'
        expect(page).to have_text '2 minutes' # 120 minutes / 52 weeks.
        expect(page).to have_text 'Percentage delivered'
        expect(page).to have_text '50%'
        expect(page).to have_text 'Status'
      end
    end

    describe 'caching' do
      context 'when a time range is updated' do
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
    end
  end

  context 'with 11 users' do
    let(:users) { create_list(:user, 11) }

    describe 'pagination' do
      it 'puts user #11 on the next page' do
        within('.table') do
          expect(page).to have_text 'Job Plan'
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
