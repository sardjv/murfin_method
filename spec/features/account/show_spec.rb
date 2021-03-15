require 'rails_helper'

describe 'Account', type: :feature do
  let(:user) { create :user }

  let!(:group_type1) { create :group_type, name: 'Band' }
  let!(:group_type2) { create :group_type, name: 'Team' }

  let!(:user_group1) { create :user_group, group_type: group_type1 }
  let!(:user_group2) { create :user_group, group_type: group_type2 }

  let!(:membership1) { create :membership, user: user, user_group: user_group1, role: 'member' }
  let!(:membership2) { create :membership, user: user, user_group: user_group2, role: 'lead' }

  before do
    log_in user
    visit root_path

    within '.navbar' do
      click_link 'Account'
    end
  end

  it 'has user details' do
    expect(page).to have_content user.email
    expect(page).to have_content user.first_name
    expect(page).to have_content user.last_name
  end

  it 'has user team and band info' do
    within ".row[data-group-type-id = '#{user_group1.id}']" do
      expect(page).to have_content group_type1.name
      expect(page).to have_content user_group1.name
      expect(page).to have_content 'member'
    end

    within ".row[data-group-type-id = '#{user_group2.id}']" do
      expect(page).to have_content group_type2.name
      expect(page).to have_content user_group2.name
      expect(page).to have_content 'lead'
    end
  end
end
