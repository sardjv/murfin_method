require 'rails_helper'

describe 'Admin downloads users csv', js: true do
  let(:admin) { create :admin }
  let!(:users) { create_list :user, 100 }

  let(:queued_msg) { 'Preparing CSV file for download. Please wait…' }
  let(:ready_msg) { 'Requested CSV file is ready.' }

  let(:filename) { "users_#{Date.current}.csv" }

  before do
    log_in admin
    visit admin_users_path
  end

  it 'shows flash messages about preparing csv and csv ready' do
    click_link 'Generate CSV'

    # expect(page).to have_css '.alert-info', text: queued_msg

    within '.alert-success' do
      page.save_screenshot
      expect(page).to have_content ready_msg
      expect(page).to have_link 'Download', href: download_admin_users_path(format: :csv)
    end
  end

  it 'downloads csv', js: false do
    visit download_admin_users_path(format: :csv)

    expect(page.response_headers['Content-Type']).to eql 'text/csv'
    expect(page.response_headers['Content-Disposition']).to include "attachment; filename=\"#{filename}\";"
  end
end
