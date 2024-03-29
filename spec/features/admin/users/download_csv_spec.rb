require 'rails_helper'

describe 'Admin downloads users csv', js: true do
  let!(:admin) { create :admin }
  let!(:users) { create_list :user, 10 }

  let(:queued_msg) { 'Preparing users CSV file for download. Please wait…' }
  let(:ready_msg) { 'Requested users CSV file is ready.' }

  let(:filename) { "users_#{Date.current}.csv" }

  before do
    log_in admin
  end

  describe 'generate' do
    before do
      visit admin_users_path
    end

    it 'shows flash messages about preparing csv and file ready for download' do
      click_link 'Generate CSV'

      expect(page).to have_no_css '.alert-info'

      within '.alert-success', wait: 3 do
        expect(page).to have_content ready_msg
        expect(page).to have_link 'Download', href: download_admin_users_path(format: :csv)
      end
    end
  end

  describe 'download', js: false do
    before do
      GenerateUsersCsvJob.perform_now(current_user_id: admin.id)
    end

    it 'sends file to the browser' do
      visit download_admin_users_path(format: :csv)

      expect(page.response_headers['Content-Type']).to eql 'text/csv'
      expect(page.response_headers['Content-Disposition']).to include "attachment; filename=\"#{filename}\";"
    end
  end
end
