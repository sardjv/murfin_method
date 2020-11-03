require 'rails_helper'

describe 'User indexes plans', type: :feature, js: true do
  let(:current_user) { create(:user) }
  let!(:plan) { create(:plan, user: current_user) }
  let!(:other_plan) { create(:plan, user: create(:user)) }

  before do
    log_in current_user
    visit plans_path
  end

  it 'shows only plans for the current_user' do
    expect(page).to have_content(current_user.name)
    expect(page).not_to have_content(other_plan.user.name)
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
end
