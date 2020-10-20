require 'rails_helper'

describe 'Admin edits a time_range', type: :feature, js: true do
  let!(:time_range) { create(:time_range) }
  let(:input_value) { 1234 }

  before { log_in create(:admin) }

  it 'updates time_range' do
    visit admin_time_ranges_path

    first('.bi-pencil').click
    fill_in I18n.t('time_range.labels.value'), with: input_value
    click_button I18n.t('time_range.save')

    expect(page).to have_content(I18n.t('time_range.notice.successfully.updated'))
    expect(time_range.reload.value).to eq input_value
  end
end
