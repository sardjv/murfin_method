require 'rails_helper'

describe 'Admin creates a time_range', type: :feature, js: true do
  before { log_in create(:admin) }

  let(:input) { build(:time_range) }

  it 'creates time_range' do
    visit admin_time_ranges_path

    click_link I18n.t('time_range.add')

    bootstrap_select input.time_range_type.name, from: I18n.t('time_range.labels.time_range_type')
    fill_in I18n.t('time_range.labels.value'), with: input.value
    bootstrap_select input.user.name, from: I18n.t('time_range.labels.user')

    expect { click_button I18n.t('time_range.save') }.to change { TimeRange.count }.by(1)

    expect(page).to have_content(I18n.t('time_range.notice.successfully.created'))
  end
end
