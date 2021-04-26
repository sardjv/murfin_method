require 'rails_helper'

describe 'User indexes plans', type: :feature, js: true do
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:current_user) { create :user, first_name: first_name, last_name: last_name }

  let!(:plan) { create(:plan, user: current_user) }
  let!(:other_plan) { create(:plan, user: create(:user)) }
  let!(:signoff_plan) { create(:plan, user: create(:user), signoffs: [create(:signoff, user: current_user)]) }

  before do
    log_in current_user
    visit plans_path
  end

  it 'shows plans for the current_user and where signoff' do
    expect(page).to have_content(plan.name)
    expect(page).not_to have_content(other_plan.name)
    expect(page).to have_content(signoff_plan.name)
  end

  context 'when a user name is updated' do
    let(:new_name) { 'Hirthe'.freeze }

    before do
      plan.user.reload.update(last_name: new_name)
      visit plans_path
    end

    it 'shows the change in the plan index' do
      expect(page).to have_content(new_name)
    end
  end

  it 'has download pdf link' do
    expect(page).to have_link href: download_plan_path(plan, format: :pdf)
  end
end
