require 'rails_helper'

describe 'Admin creates a time_range', type: :feature, js: true do
  let(:admin) { create :admin }
  let(:input) { build :time_range }
  let(:hours) { Faker::Number.between(from: 1, to: 16) }
  let(:success_message) { I18n.t('notice.successfully.created', model_name: TimeRange.model_name.human) }
  let(:error_message) { I18n.t('notice.could_not_be.created', model_name: TimeRange.model_name.human) }
  let(:time_range) { TimeRange.unscoped.last }

  before do
    log_in admin
    visit admin_time_ranges_path
    click_link I18n.t('actions.add', model_name: TimeRange.model_name.human.titleize)
  end

  def set_required_fields
    bootstrap_select input.time_range_type.name, from: TimeRange.human_attribute_name('time_range_type')
    bootstrap_select input.user.name, from: TimeRange.human_attribute_name('user')
    within_form_field 'Appointment duration' do
      find_field(type: 'number', match: :first).set(hours)
    end
  end

  context 'without start and end time' do
    it 'creates with defaults to 9:00 to 17:00' do
      set_required_fields

      expect { click_button I18n.t('actions.save') }.to change { TimeRange.count }.by(1)

      expect(page).to have_css '.alert-info', text: success_message

      expect(time_range.start_time.strftime('%H:%M')).to eq '09:00'
      expect(time_range.end_time.strftime('%H:%M')).to eq '17:00'
    end
  end

  context 'with start and end time' do
    before do
      set_required_fields
      bootstrap_select_year input.start_time.year + 1, from: TimeRange.human_attribute_name('end_time')

      fill_in 'Appointment ID', with: input.appointment_id
    end

    it 'creates time_range' do
      expect { click_button I18n.t('actions.save') }.to change { TimeRange.count }.by(1)

      expect(page).to have_css '.alert-info', text: success_message
    end

    context 'end time before start time' do
      before do
        bootstrap_select_year input.start_time.year - 2, from: TimeRange.human_attribute_name('end_time')
      end

      let!(:error_details) { 'must occur after start time' }

      it 'does not save' do
        expect { click_button I18n.t('actions.save') }.not_to change(TimeRange, :count)

        expect(page).to have_css '.alert-danger', text: error_message

        within_invalid_form_field 'End time' do
          expect(page).to have_content error_details
        end
      end
    end
  end

  context 'with tags' do
    let(:tag_type1) { create :tag_type }
    let(:tag_type2) { create :tag_type }
    let(:tag_type3) { create :tag_type }

    let!(:tag1a) { create :tag, tag_type: tag_type1 }
    let!(:tag1b) { create :tag, tag_type: tag_type1 }
    let!(:tag1c) { create :tag, tag_type: tag_type1 }

    let!(:tag2a) { create :tag, tag_type: tag_type2 }
    let!(:tag2b) { create :tag, tag_type: tag_type2 }

    let!(:tag3a) { create :tag, tag_type: tag_type3 }
    let!(:tag3b) { create :tag, tag_type: tag_type3 }

    before do
      visit current_path
    end

    it 'creates time_range with two tags' do
      set_required_fields

      bootstrap_select tag1b.name, from: tag_type1.name
      bootstrap_select tag3b.name, from: tag_type3.name

      expect do
        click_button 'Save'

        expect(page).to have_css '.alert-info', text: success_message
      end.to change { TagAssociation.count }.by(2)

      expect(time_range.tag_associations.pluck(:tag_id)).to eql [tag1b.id, tag3b.id]
    end
  end
end
