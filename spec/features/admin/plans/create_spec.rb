require 'rails_helper'

describe 'Admin creates plan on behalf of a user', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:user) { create :user }
  let!(:user2) { create :user }

  let(:hours_per_week) { 8 }
  let(:plan) { Plan.unscoped.last }

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

    expect { click_button 'Save' }.to change { Plan.count }.by(1)

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: Plan.model_name.human))
    expect(plan.user_id).to eq(user2.id)
    expect(plan.activities.count).to eq(1)
    expect(plan.end_date).to eq(Plan.last.start_date + 1.year - 1.day)
    expect(plan.signoffs.pluck(:user_id)).to eq [user2.id]
  end

  context 'when invalid' do
    it 'shows errors' do
      click_link 'Add Activity'
      click_button 'Save'

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: Plan.model_name.human))
      expect(page).to have_content("#{Activity.human_attribute_name('duration')} #{I18n.t('errors.activity.duration.missing')}")
    end
  end
end
