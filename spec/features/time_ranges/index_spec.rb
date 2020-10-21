require 'rails_helper'

describe 'User indexes time ranges', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:time_range) { create(:time_range, user: current_user) }
  let!(:other_time_range) { create(:time_range, user: create(:user)) }

  before do
    log_in current_user
    visit time_ranges_path
  end

  it 'shows only time_ranges for the current_user' do
    expect(page).to have_content(current_user.name)
    expect(page).not_to have_content(other_time_range.user.name)
  end

  context 'when a user name is updated' do
    let(:new_name) { 'Hirthe'.freeze }

    before do
      time_range.user.update(last_name: new_name)
      visit time_ranges_path
    end

    it 'shows the change in the time range index' do
      expect(page).to have_content(new_name)
    end
  end
end
