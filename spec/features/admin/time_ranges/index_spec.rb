require 'rails_helper'

describe 'Time range index', type: :feature, js: true do
  let!(:time_range) { create(:time_range) }
  let(:new_name) { 'Hirthe'.freeze }

  before { log_in create(:admin) }

  context 'when a user name is updated' do
    before do
      visit admin_time_ranges_path # Set any caches.

      time_range.user.update(last_name: new_name)

      visit admin_time_ranges_path
    end

    it 'shows the change in the time range index' do
      expect(page).to have_content(new_name)
    end
  end
end
