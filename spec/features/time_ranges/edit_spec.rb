require 'rails_helper'

describe 'User edits a time_range', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:time_range) { create(:time_range, user: current_user) }
  let(:input_value) { 1234 }

  before do
    log_in current_user
    visit time_ranges_path
    first('.bi-pencil').click
  end

  it 'updates time_range' do
    fill_in I18n.t('time_range.labels.value'), with: input_value
    click_button I18n.t('time_range.save')

    expect(page).to have_content(I18n.t('time_range.notice.successfully.updated'))
    expect(time_range.reload.value).to eq input_value
  end

  context 'with end before start' do
    before do
      bootstrap_select time_range.start_time.year - 2, from: I18n.t('time_range.labels.end_time')
    end

    it 'does not save' do
      expect { click_button I18n.t('time_range.save') }.not_to change(TimeRange, :count)

      expect(page).to have_content(I18n.t('time_range.notice.could_not_be.updated'))
    end
  end
end
