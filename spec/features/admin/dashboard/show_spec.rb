require 'rails_helper'

describe 'Admin Dashboard', type: :feature do
  let(:user) { create(:user) }
  let!(:plan) do
    create(
      :plan,
      user_id: user.id,
      start_date: 1.week.ago,
      end_date: Time.current
    )
  end

  before do
    log_in create(:admin)
    visit admin_dashboard_path
  end

  it 'has user and job plan count' do
    within('#box-users') do
      expect(page).to have_text '2'
      expect(page).to have_text 'Users'
    end
    within('#box-job-plans') do
      expect(page).to have_text '1'
      expect(page).to have_text 'Plan'
    end
  end
end
