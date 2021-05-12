require 'rails_helper'

describe 'User creates a plan', type: :feature, js: true do
  let!(:first_user_in_lists) { create(:user, first_name: '___Aardvark') }
  let(:current_user) { create(:user) }
  let(:hours_per_week) { 4 }

  before do
    log_in current_user
    visit plans_path
    click_link I18n.t('actions.add', model_name: Plan.model_name.human.titleize)
  end

  it 'creates plan for the current_user' do
    # wait_for_ajax
    click_link I18n.t('actions.add', model_name: Activity.model_name.human.titleize)
    find_field(type: 'number', match: :first).set(hours_per_week)

    expect { click_button I18n.t('actions.save') }.to change { Plan.count }.by(1)

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: Plan.model_name.human))
    expect(Plan.last.user_id).to eq(current_user.id)
    expect(Plan.last.activities.count).to eq(1)
    expect(Plan.last.end_date).to eq(Plan.last.start_date + 1.year - 1.day)
    expect(Plan.last.signoffs.first.user).to eq(current_user)
  end

  context 'when invalid' do
    it 'shows errors' do
      click_link I18n.t('actions.add', model_name: Activity.model_name.human.titleize)
      click_button I18n.t('actions.save')
      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: Plan.model_name.human))
      expect(page).to have_content("#{Activity.human_attribute_name('duration')} #{I18n.t('errors.activity.duration.missing')}")
    end
  end
end
