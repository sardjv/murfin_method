require 'rails_helper'

describe 'Admin downloads users csv', js: true do
  let!(:admin) { create :admin, id: 123 }
  let!(:users) { create_list :user, 10 }

  let(:queued_msg) { 'Preparing CSV file for download. Please wait…' }
  let(:ready_msg) { 'Requested CSV file is ready.' }

  let(:tmp_filename) { "users_#{Date.current}_#{admin.id}.csv" }
  let(:filename) { "users_#{Date.current}.csv" }
  let(:tmp_file_path) { Rails.root.join('tmp', tmp_filename) }

  before do
    log_in admin
  end

  describe 'generate' do
    before do
      visit admin_users_path
    end

    it 'test' do
      click_link 'Generate CSV'

      expect(page).to have_css '.alert-info', text: queued_msg
      expect(page).to have_no_css '.alert-info', text: queued_msg

      within '.alert-success' do
        expect(page).to have_content ready_msg
      end
    end

    it 'shows flash messages about preparing and csv ready for download' do
      click_link 'Generate CSV'
      #expect(GenerateUsersCsvJob).to receive(:perform_later).with({ current_user_id: admin.id })

      expect(page).not_to have_css '.alert-info', text: queued_msg


      #expect(File.exist?(tmp_file_path)).to eql true
      # TODO: fails on CircleCI
      within '.alert-success', wait: 5 do
        expect(page).to have_content ready_msg

        expect(page).to have_link 'Download', href: download_admin_users_path(format: :csv)
        click_link 'Download'
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
