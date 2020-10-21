require 'rails_helper'

describe 'User creates a time_range', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let(:input) { build(:time_range) }

  before do
    log_in current_user
    visit time_ranges_path
    click_link I18n.t('time_range.add')
    bootstrap_select input.time_range_type.name, from: I18n.t('time_range.labels.time_range_type')
    fill_in I18n.t('time_range.labels.value'), with: input.value
  end

  it 'creates time_range for the current_user' do
    expect { click_button I18n.t('time_range.save') }.to change { TimeRange.count }.by(1)

    expect(TimeRange.last.user_id).to eq(current_user.id)
    expect(page).to have_content(I18n.t('time_range.notice.successfully.created'))
  end

  context 'with end before start' do
    before do
      bootstrap_select input.start_time.year - 2, from: I18n.t('time_range.labels.end_time')
    end

    it 'does not save' do
      expect { click_button I18n.t('time_range.save') }.not_to change(TimeRange, :count)

      expect(page).to have_content(I18n.t('time_range.notice.could_not_be.created'))
    end
  end
end