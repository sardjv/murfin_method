require 'rails_helper'

describe 'Team Individuals', type: :feature do
  let(:plan_id) { TimeRangeType.plan_type.id }
  let(:actual_id) { TimeRangeType.actual_type.id }

  before :each do
    users.each do |user|
      create_list(
        :time_range,
        10,
        user_id: user.id,
        time_range_type_id: plan_id,
        start_time: 1.week.ago,
        end_time: Time.zone.now,
        value: 10
      )
      create_list(
        :time_range,
        10,
        user_id: user.id,
        time_range_type_id: actual_id,
        start_time: 1.week.ago,
        end_time: Time.zone.now,
        value: 5
      )
    end
    log_in users.first
    visit individuals_teams_path
  end

  context 'with 1 user' do
    let(:users) { [create(:user)] }
    let(:user) { users.first }

    it 'has table with planned and actual data' do
      expect(page).to have_text 'Percentage delivered against job plan'
      within('.table') do
        expect(page).to have_text 'Job Plan'
        expect(page).to have_text '1.9'
        expect(page).to have_text 'RIO Data'
        expect(page).to have_text '1.0'
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
