require 'rails_helper'

describe 'Admin edits a time_range', type: :feature, js: true do
  let!(:time_range) { create :time_range, seconds_worked: 3600 } # 1h
  let(:new_hours) { Faker::Number.between(from: 1, to: 16) }
  let(:new_appointment_id) { Faker::Lorem.characters(number: 8) }

  let(:success_message) { I18n.t('notice.successfully.updated', model_name: TimeRange.model_name.human) }
  let(:error_message) { I18n.t('notice.could_not_be.updated', model_name: TimeRange.model_name.human) }

  before do
    log_in create(:admin)
    visit admin_time_ranges_path
    first('.bi-pencil').click
  end

  it 'updates time_range' do
    within_form_field 'Appointment duration' do
      find_field(type: 'number', match: :first).set(new_hours)
    end
    fill_in 'Appointment ID', with: new_appointment_id

    click_button I18n.t('actions.save')
    expect(page).to have_css '.alert-info', text: success_message

    expect(time_range.reload.value.to_i).to eq BigDecimal(new_hours * 60).to_i
    expect(time_range.appointment_id).to eq new_appointment_id
  end

  context 'end time before start time' do
    let(:error_details) { 'must occur after start time' }

    it 'shows error message' do
      bootstrap_select_year time_range.start_time.year - 2, from: TimeRange.human_attribute_name('end_time')
      click_button I18n.t('actions.save')

      expect(page).to have_css '.alert-danger', text: error_message

      within_invalid_form_field 'End time' do
        expect(page).to have_content error_details
      end
    end
  end

  describe 'appointment duration set to zero' do
    let(:error_details) { 'must be greater than 0' }

    it 'shows error message' do
      within_form_field 'Appointment duration' do
        find_field(type: 'number', match: :first).set(0) # 0 hours
      end

      click_button I18n.t('actions.save')

      expect(page).to have_css '.alert-danger', text: error_message

      within_invalid_form_field 'Appointment duration' do
        expect(page).to have_content error_details
      end
    end
  end
end
