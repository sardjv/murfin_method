require 'rails_helper'

describe 'Admin creates a group type', type: :feature, js: true do
  before { log_in create(:admin) }

  it 'creates group type' do
    visit admin_group_types_path

    click_link I18n.t('group_types.add')
    fill_in I18n.t('group_types.labels.name'), with: 'Band'
    click_button I18n.t('group_types.save')

    expect(page).to have_content(I18n.t('group_types.notice.successfully.created'))
    expect(GroupType.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:group_type) { create(:group_type, name: 'Band') }
    it 'does not create group type' do
      visit admin_group_types_path

      click_link I18n.t('group_types.add')
      fill_in I18n.t('group_types.labels.name'), with: 'Band'
      click_button I18n.t('group_types.save')

      expect(page).to have_content(I18n.t('group_types.notice.could_not_be.created'))
      expect(GroupType.all.count).to eq 1
    end
  end
end
