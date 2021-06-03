require 'rails_helper'

describe 'Admin creates plan on behalf of a user', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:user1) { create :user }
  let!(:user2) { create :user }

  let(:hours_per_week) { 8 }
  let(:plan) { Plan.unscoped.last }

  let(:default_start_date) { Plan::DEFAULT_START_DATE }
  let(:default_end_date) { Plan::DEFAULT_END_DATE }

  let(:success_message) { I18n.t('notice.successfully.created', model_name: Plan.model_name.human) }

  before do
    log_in admin
    visit admin_plans_path

    click_link 'Add Job Plan'
  end

  it 'creates plan for the selected user' do
    expect(current_path).to eql new_plan_path

    within '.plan-user-id-form-group' do
      bootstrap_select user2.name, from: 'User'
    end

    click_link 'Add Activity'
    find_field(type: 'number', match: :first).set(hours_per_week)

    within '#plan-signoffs' do
      bootstrap_select user2.name, from: 'User'
    end

    click_button 'Save'

    expect(page).to have_css '.alert-info', text: success_message
    expect(plan.user_id).to eq(user2.id)
    expect(plan.activities.count).to eq(1)
    expect(plan.start_date).to eql default_start_date
    expect(plan.end_date).to eql default_end_date
    expect(plan.signoffs.pluck(:user_id)).to eq [user2.id]
  end

  context 'when invalid' do
    let(:error_message) { I18n.t('notice.could_not_be.created', model_name: Plan.model_name.human) }

    it 'shows errors' do
      click_link 'Add Activity'
      click_button 'Save'

      expect(page).to have_css '.alert-danger', text: error_message
      expect(page).to have_content("#{Activity.human_attribute_name('duration')} #{I18n.t('errors.activity.duration.missing')}")
    end
  end
end
