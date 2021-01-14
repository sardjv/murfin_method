require 'rails_helper'

describe 'Admin indexes plans', type: :feature, js: true do
  let(:current_user) { create(:user, admin: true) }
  let!(:plan) { create(:plan, user: current_user) }
  let!(:other_plan) { create(:plan, user: create(:user)) }
  let!(:signoff_plan) { create(:plan, user: create(:user), signoffs: [create(:signoff, user: current_user)]) }

  before do
    log_in current_user
    visit admin_plans_path
  end

  it 'shows all plans' do
    expect(page).to have_content(plan.name)
    expect(page).to have_content(other_plan.name)
    expect(page).to have_content(signoff_plan.name)
  end
end
