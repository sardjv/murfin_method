require 'rails_helper'

describe 'Admin logs in', type: :feature do
  before { log_in create(:admin) }

  context 'with valid credentials' do
    it 'logs them in' do
      visit admin_dashboard_path

      expect(page).to have_content 'Admin dashboard'
    end
  end
end
