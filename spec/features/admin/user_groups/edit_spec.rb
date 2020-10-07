require 'rails_helper'

describe 'Admin edits a user group', type: :feature, js: true do
  let(:admin) do
    create(:admin, first_name: 'John',
                   last_name: 'Smith',
                   email: 'john@example.com')
  end
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:user_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end
  let!(:other_user_group) do
    create(:user_group, group_type: group_type, name: 'Band 2')
  end

  it 'updates user group' do
    visit admin_group_types_path

    page.click_on('Bands')
    within('.card-body') do
      first('.bi-pencil').click
    end
    fill_in I18n.t('user_groups.labels.name'), with: 'NHS Band 1'
    click_button I18n.t('user_groups.save')

    expect(page).to have_content(I18n.t('user_groups.notice.successfully.updated'))
    expect(user_group.reload.name).to eq 'NHS Band 1'
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

      expect(page).to have_content(I18n.t('user_groups.notice.could_not_be.updated'))
      expect(user_group.reload.name).to eq 'Band 1'
    end
  end
end