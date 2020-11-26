require 'rails_helper'

describe 'Admin creates a time_range', type: :feature, js: true do
  let(:input) { build(:time_range) }

  before do
    log_in create(:admin)
    visit admin_time_ranges_path
    click_link I18n.t('time_range.add')
    bootstrap_select input.time_range_type.name, from: I18n.t('time_range.labels.time_range_type')
    bootstrap_select input.start_time.year + 1, from: I18n.t('time_range.labels.end_time')
    find_field(type: 'number', match: :first).set(input.value)
    bootstrap_select input.user.name, from: I18n.t('time_range.labels.user')
  end

  it 'creates time_range' do
    expect { click_button I18n.t('time_range.save') }.to change { TimeRange.count }.by(1)

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: TimeRange.model_name.human))
  end

  context 'with end before start' do
    before do
      bootstrap_select input.start_time.year - 2, from: I18n.t('time_range.labels.end_time')
    end

    it 'does not save' do
      expect { click_button I18n.t('time_range.save') }.not_to change(TimeRange, :count)

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: TimeRange.model_name.human))
    end
  end
end
