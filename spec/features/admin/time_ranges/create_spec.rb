require 'rails_helper'

describe 'Admin creates a time_range', type: :feature, js: true do
  let(:input) { build(:time_range) }

  context "when don't enter start and end time" do
    before do
      log_in create(:admin)
      visit admin_time_ranges_path
      click_link I18n.t('actions.add', model_name: TimeRange.model_name.human.titleize)
      bootstrap_select input.time_range_type.name, from: TimeRange.human_attribute_name('time_range_type')
      bootstrap_select input.user.name, from: TimeRange.human_attribute_name('user')
    end
    it 'defaults to 9:00 to 17:00' do
      expect { click_button I18n.t('actions.save') }.to change { TimeRange.count }.by(1)
      expect(TimeRange.first.start_time.strftime('%H:%M')).to eq '09:00'
      expect(TimeRange.first.end_time.strftime('%H:%M')).to eq '17:00'
    end
  end

  context 'when enter values' do
    before do
      log_in create(:admin)
      visit admin_time_ranges_path
      click_link I18n.t('actions.add', model_name: TimeRange.model_name.human.titleize)
      bootstrap_select input.time_range_type.name, from: TimeRange.human_attribute_name('time_range_type')
      bootstrap_select input.start_time.year + 1, from: TimeRange.human_attribute_name('end_time')
      find_field(type: 'number', match: :first).set(input.value)
      bootstrap_select input.user.name, from: TimeRange.human_attribute_name('user')
    end

    it 'creates time_range' do
      expect { click_button I18n.t('actions.save') }.to change { TimeRange.count }.by(1)

      expect(page).to have_content(I18n.t('notice.successfully.created', model_name: TimeRange.model_name.human))
    end

    context 'with end before start' do
      before do
        bootstrap_select input.start_time.year - 2, from: TimeRange.human_attribute_name('end_time')
      end

      it 'does not save' do
        expect { click_button I18n.t('actions.save') }.not_to change(TimeRange, :count)

        expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: TimeRange.model_name.human))
      end
    end
  end
end
