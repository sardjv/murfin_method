require 'rails_helper'

describe 'Admin downloads plans csv', js: true do
  let!(:admin) { create :admin }
  let!(:plans) { create_list :plan, 10 }

  let(:queued_msg) { 'Preparing plans CSV file for download. Please wait…' }
  let(:ready_msg) { 'Requested plans CSV file is ready.' }

  let(:filename) { "plans_#{Date.current}.csv" }

  before do
    log_in admin
  end

  describe 'generate' do
    before do
      visit admin_plans_path
    end

    it 'shows flash messages about preparing csv and file ready for download' do
      click_link 'Generate CSV'

      if page.has_css?('.alert-info', wait: 0)
        expect(page).to have_content queued_msg
      end

      expect(page).to have_no_css '.alert-info'

      within '.alert-success', wait: 3 do
        expect(page).to have_content ready_msg
        expect(page).to have_link 'Download', href: download_admin_plans_path(format: :csv)
      end
    end
  end

  describe 'download', js: false do
    before do
      GeneratePlansCsvJob.perform_now(current_user_id: admin.id)
    end

    it 'sends file to the browser' do
      visit download_admin_plans_path(format: :csv)

      expect(page.response_headers['Content-Type']).to eql 'text/csv'
      expect(page.response_headers['Content-Disposition']).to include "attachment; filename=\"#{filename}\";"
    end
  end
end
