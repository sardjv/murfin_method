require 'rails_helper'

describe 'Admin destroys a time range', type: :feature, js: true do
  let!(:time_range) { create(:time_range) }

  before { log_in create(:admin) }

  it 'destroys time range' do
    visit admin_time_ranges_path

    accept_confirm { first('.bi-trash').click }

    expect(page).to have_content(I18n.t('time_range.notice.successfully.destroyed'))
    refute(TimeRange.exists?)
  end
end
