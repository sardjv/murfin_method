require 'rails_helper'

describe 'Admin creates plan on behalf of a user', type: :feature, js: true do
  let!(:admin) { create :admin }
  let!(:user1) { create :user }
  let!(:user2) { create :user }

  let(:activity_hours_per_week) { Faker::Number.between(from: 1, to: 16) }

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
    within '#plan-activities-table' do
      find_field(type: 'number', match: :first).set(activity_hours_per_week)
    end

    within '#plan-signoffs' do
      bootstrap_select user2.name, from: 'User'
    end

    click_button 'Save'

    expect(page).to have_css '.alert-info', text: success_message

    expect(plan.user_id).to eq(user2.id)
    expect(plan.activities.count).to eq(1)
    expect(plan.start_date).to eql default_start_date
    expect(plan.end_date).to eql default_end_date
    expect(plan.contracted_minutes_per_week).to eql 0
    expect(plan.signoffs.pluck(:user_id)).to eq [user2.id]
  end

  context 'with tags' do
    let(:tag_type1) { create :tag_type }
    let(:tag_type2) { create :tag_type }
    let(:tag_type3) { create :tag_type }

    let!(:tag1a) { create :tag, tag_type: tag_type1 }
    let!(:tag1b) { create :tag, tag_type: tag_type1 }

    let!(:tag2a) { create :tag, tag_type: tag_type2 }
    let!(:tag2b) { create :tag, tag_type: tag_type2 }

    before do
      visit new_plan_path
    end

    it 'creates plan with activity and tag' do
      within '.plan-user-id-form-group' do
        bootstrap_select user2.name, from: 'User'
      end

      click_link 'Add Activity'

      within '.activities .nested-fields' do
        bootstrap_select tag1a.name, from: tag_type1.name

        find_field(type: 'number', match: :first).set(activity_hours_per_week)
      end

      expect do
        click_button 'Save'
      end.to change { TagAssociation.count }.by(1)

      expect(page).to have_css '.alert-info', text: success_message

      expect(plan.activities.count).to eq 1
      expect(plan.activities.first.tags.pluck(:id)).to eql [tag1a.id]
    end
  end

  context 'activity has missing time worked per week' do
    let(:error_message) { I18n.t('notice.could_not_be.created', model_name: Plan.model_name.human) }
    let(:error_details) { 'Time worked per week required' }

    it 'shows errors' do
      click_link 'Add Activity'
      click_button 'Save'

      expect(page).to have_css '.alert-danger', text: error_message

      within '.time-worked-per-week' do
        expect(page).to have_content error_details
      end
    end
  end
end
