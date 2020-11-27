require 'rails_helper'

describe 'Admin edits a user group', type: :feature, js: true do
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:user_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end
  let!(:membership) { create(:membership, user_group: user_group, user: create(:user)) }

  before { log_in create(:admin) }

  context 'when user group has members' do
    it 'can set a memebr to be a lead of the group' do
      visit edit_admin_user_group_path(user_group)

      choose(UserGroup.human_attribute_name('lead'))
      click_button I18n.t('actions.save')
      expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: UserGroup.model_name.human))
      expect(user_group.reload.name).to eq 'Band 1'
    end
  end
end
