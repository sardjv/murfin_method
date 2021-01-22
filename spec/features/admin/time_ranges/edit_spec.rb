require 'rails_helper'

describe 'Admin edits a time_range', type: :feature, js: true do
  let!(:time_range) { create(:time_range, value: 0) }
  let(:input_value) { 1234 }

  before do
    log_in create(:admin)
    visit admin_time_ranges_path
    first('.bi-pencil').click
  end

  it 'updates time_range' do
    find_field(type: 'number', match: :first).set(input_value)
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: TimeRange.model_name.human))
    expect(time_range.reload.value).to eq input_value * 60
  end

  context 'with end before start' do
    before do
      bootstrap_select_year time_range.start_time.year - 2, from: TimeRange.human_attribute_name('end_time')
    end

    it 'does not save' do
      expect { click_button I18n.t('actions.save') }.not_to change(TimeRange, :count)

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: TimeRange.model_name.human))
    end
  end
end
