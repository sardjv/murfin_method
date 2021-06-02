require 'rails_helper'

describe 'User creates a plan', type: :feature, js: true do
  let(:current_user) { create :user }
  let(:default_working_hours_per_week) { 37.5 }
  let(:activity_hours_per_week) { 4 }
  let(:hours_per_week) { 4 }
  let(:plan) { Plan.unscoped.last }

  let(:start_date) { Date.current.change(month: 5, day: 1) } # May current year
  let(:end_date) { Date.current.change(year: Date.current.year + 1, month: 2).end_of_month } # Feb next year

  let(:success_message) { I18n.t('notice.successfully.created', model_name: Plan.model_name.human) }

  before do
    log_in current_user
    visit plans_path

    click_link I18n.t('actions.add', model_name: Plan.model_name.human.titleize)
  end

  it 'creates plan for the current_user' do
    find('.plan-start-date-container input').click

    within '.flatpickr-monthSelect-months' do
      find(:xpath, "span[text() = 'May']").click # May current year
    end

    find('.plan-end-date-container input').click

    within '.flatpickr-monthSelect-months' do # Feb next year
      find(:xpath, "span[text() = 'Feb']").click
    end

    click_link I18n.t('actions.add', model_name: Activity.model_name.human.titleize)

    find_field(type: 'number', match: :first).set(activity_hours_per_week)

    click_button 'Save'

    expect(page).to have_css '.alert-info', text: success_message

    expect(plan.user).to eq current_user
    expect(plan.activities.count).to eq(1)
    expect(plan.start_date).to eql start_date
    expect(plan.end_date).to eql end_date
    expect(plan.working_hours_per_week).to eql default_working_hours_per_week
    expect(plan.signoffs.pluck(:user_id)).to eql [current_user.id]
  end

  context 'missing activity duration' do
    let(:error_message) { I18n.t('notice.could_not_be.created', model_name: Plan.model_name.human) }
    let(:activity_duration_error_details) { "#{Activity.human_attribute_name('duration')} #{I18n.t('errors.activity.duration.missing')}" }

    it 'shows errors' do
      click_link I18n.t('actions.add', model_name: Activity.model_name.human.titleize)
      click_button I18n.t('actions.save')

      expect(page).to have_css '.alert-danger', text: error_message
      expect(page).to have_content activity_duration_error_details
    end
  end
end
