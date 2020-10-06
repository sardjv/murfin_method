require 'rails_helper'

describe 'Admin edits a group type', type: :feature, js: true do
  let(:admin) do
    create(:admin, first_name: 'John',
                   last_name: 'Smith',
                   email: 'john@example.com')
  end
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:other_group_type) do
    create(:group_type, name: 'Health Visitor')
  end

  it 'updates group type' do
    visit admin_group_types_path

    first('.bi-pencil').click
    fill_in I18n.t('group_types.labels.name'), with: 'NHS Band'
    click_button I18n.t('group_types.save')

    expect(page).to have_content(I18n.t('group_types.notice.successfully.updated'))
    expect(group_type.reload.name).to eq 'NHS Band'
  end

  context 'when enter non unique name' do
    it 'does not update group type' do
      visit admin_group_types_path

      first('.bi-pencil').click
      fill_in I18n.t('group_types.labels.name'), with: 'Health Visitor'
      click_button I18n.t('group_types.save')

      expect(page).to have_content(I18n.t('group_types.notice.could_not_be.updated'))
      expect(group_type.reload.name).to eq 'Band'
    end
  end
end
