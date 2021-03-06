require 'rails_helper'

describe 'Admin creates a user group', type: :feature, js: true do
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  before { log_in create(:admin) }

  it 'creates user group' do
    visit admin_group_types_path

    within('.card-header') do
      first('.bi-plus').click
    end

    fill_in UserGroup.human_attribute_name('name'), with: 'Band 1'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: UserGroup.model_name.human))
    expect(UserGroup.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:user_group) do
      create(:user_group, group_type: group_type, name: 'Band 1')
    end
    it 'does not create user group' do
      visit admin_group_types_path

      within('.card-header') do
        first('.bi-plus').click
      end
      fill_in UserGroup.human_attribute_name('name'), with: 'Band 1'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: UserGroup.model_name.human))
      expect(UserGroup.all.count).to eq 1
    end
  end
end
