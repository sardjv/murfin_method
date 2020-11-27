require 'rails_helper'

describe 'Admin creates a group type', type: :feature, js: true do
  before { log_in create(:admin) }

  it 'creates group type' do
    visit admin_group_types_path

    click_link I18n.t('actions.add', model_name: GroupType.model_name.human)
    fill_in GroupType.human_attribute_name('name'), with: 'Band'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: GroupType.model_name.human))
    expect(GroupType.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:group_type) { create(:group_type, name: 'Band') }
    it 'does not create group type' do
      visit admin_group_types_path

      click_link I18n.t('actions.add', model_name: GroupType.model_name.human)
      fill_in GroupType.human_attribute_name('name'), with: 'Band'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: GroupType.model_name.human))
      expect(GroupType.all.count).to eq 1
    end
  end
end
