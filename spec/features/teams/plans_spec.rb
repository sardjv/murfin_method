require 'rails_helper'

describe 'Manager indexes plans', type: :feature, js: true do
  let!(:manager) { create(:user) }
  let!(:user_group) { create(:user_group) }
  let!(:lead_membership) { create(:membership, user_group: user_group, user: manager, role: 'lead') }
  let!(:team_member) { create(:user) }
  let!(:team_member_membership) { create(:membership, user_group: user_group, user: team_member) }

  let!(:manager_plan) { create(:plan, user: manager) }
  let!(:team_member_plan) { create(:plan, user: team_member) }
  let!(:other_plan) { create(:plan, user: create(:user)) }
  let!(:signoff_plan) { create(:plan, user: create(:user), signoffs: [create(:signoff, user: manager)]) }

  before do
    log_in manager
    visit plans_team_path(user_group)
  end

  it 'shows plans for the team' do
    expect(page).to have_content(manager_plan.name)
    expect(page).to have_content(team_member_plan.name)
    expect(page).not_to have_content(other_plan.name)
    expect(page).not_to have_content(signoff_plan.name)
  end
end
