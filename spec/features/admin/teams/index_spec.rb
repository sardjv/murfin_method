require 'rails_helper'

describe 'Teams', type: :feature do
  let(:admin) { create :admin }
  let(:manager1) { create :user }
  let(:manager2) { create :user }
  let(:team_member) { create :user }

  let(:user_group1) { create :user_group }
  let!(:lead_membership1) { create :membership, user_group: user_group1, user: manager1, role: 'lead' }

  let(:user_group2) { create :user_group }
  let!(:team_member_membership) { create :membership, user_group: user_group2, user: team_member }

  let(:user_group3) { create :user_group }
  let!(:lead_membership2) { create :membership, user_group: user_group3, user: manager2, role: 'lead' }

  let(:user_group4) { create :user_group }

  it 'lists only user groups with lead' do
    log_in admin

    within '.thin-tabs' do
      click_link 'Teams'
    end

    within 'table#user-groups-with-lead' do
      expect(page).to have_content user_group1.name
      expect(page).not_to have_content user_group2.name
      expect(page).to have_content user_group3.name
      expect(page).not_to have_content user_group4.name
    end
  end
end
