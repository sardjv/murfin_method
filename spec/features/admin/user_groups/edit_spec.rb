require 'rails_helper'

describe 'Admin edits a user group', type: :feature, js: true do
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:band1_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end
  let!(:band2_group) do
    create(:user_group, group_type: group_type, name: 'Band 2')
  end

  before { log_in create(:admin) }

  it 'updates user group' do
    visit admin_group_types_path

    page.click_on('Bands')
    within('.card-body') do
      first('.bi-pencil').click
    end
    fill_in I18n.t('user_groups.labels.name'), with: 'NHS Band 1'
    click_button I18n.t('user_groups.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: UserGroup.model_name.human))
    expect(band1_group.reload.name).to eq 'NHS Band 1'
  end

  context 'when enter non unique name' do
    it 'does not update user group' do
      visit admin_group_types_path

      page.click_on('Bands')
      within('.card-body') do
        first('.bi-pencil').click
      end
      fill_in I18n.t('user_groups.labels.name'), with: 'Band 2'
      click_button I18n.t('user_groups.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: UserGroup.model_name.human))
      expect(band1_group.reload.name).to eq 'Band 1'
    end
  end
end
