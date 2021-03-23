require 'rails_helper'

describe 'API Tokens index', type: :feature, js: true do
  let!(:api_user) { create(:api_user) }

  before do
    log_in create(:admin)
    visit admin_api_users_path
  end

  it 'shows all API Users' do
    expect(page).to have_content(api_user.name)
    expect(page).to have_content(api_user.contact_email)
  end
end
