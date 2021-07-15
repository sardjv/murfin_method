require 'rails_helper'

describe 'Time range index', type: :feature, js: true do
  let!(:time_range1) { create :time_range, start_time: 1.hour.ago, user: create(:user) }
  let!(:time_range2) { create :time_range, start_time: 1.day.ago, user: create(:user) }
  let!(:time_range3) { create :time_range, start_time: 1.minute.ago, user: create(:user) }

  before do
    log_in create(:admin)

    visit admin_time_ranges_path # Set any caches.
  end

  it 'shows time ranges ordered by start time descending' do
    expect(time_range3.user.name).to appear_before time_range1.user.name
    expect(time_range1.user.name).to appear_before time_range2.user.name
  end

  context 'when a user name is updated' do
    let(:new_name) { 'Hirthe'.freeze }

    it 'shows the change in the time range index' do
      time_range1.user.update(last_name: new_name)
      visit admin_time_ranges_path

      expect(page).to have_content(new_name)
    end
  end
end
