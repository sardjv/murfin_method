require 'rails_helper'

describe 'Admin adds a user to a group', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  let!(:group_type1) { create(:group_type, name: 'Band') }
  let!(:group_type2) { create(:group_type, name: 'Team') }

  let!(:band1_group) { create(:user_group, group_type: group_type1, name: 'Band 1') }
  let!(:band2_group) { create(:user_group, group_type: group_type1, name: 'Band 2') }
  let!(:band3_group) { create(:user_group, group_type: group_type1, name: 'Band 3') }

  let!(:team1_group) { create(:user_group, group_type: group_type2, name: 'Team 1') }
  let!(:team2_group) { create(:user_group, group_type: group_type2, name: 'Team 2') }
  let!(:team3_group) { create(:user_group, group_type: group_type2, name: 'Team 3') }

  before do
    log_in admin
  end

  it 'updates user groups' do
    visit edit_admin_user_path(user)

    expect(page).to have_bootstrap_select('Band', options: ['', 'Band 1', 'Band 2', 'Band 3'])
    bootstrap_select ['Band 1', 'Band 2'], from: 'Band'

    expect(page).to have_bootstrap_select('Team', options: ['', 'Team 1', 'Team 2', 'Team 3'])
    bootstrap_select ['Team 1', 'Team 3'], from: 'Team'

    click_button 'Save'

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
    expect(user.user_groups.pluck(:name)).to match_array ['Band 1', 'Band 2', 'Team 1', 'Team 3']
  end
end
