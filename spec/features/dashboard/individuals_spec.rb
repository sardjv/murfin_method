require 'rails_helper'

describe 'Dashboard Individuals', type: :feature do
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
    visit individuals_dashboard_path
  end

  context 'with 1 user' do
    let(:users) { [create(:user)] }

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
