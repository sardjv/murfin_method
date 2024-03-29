require 'rails_helper'

describe 'Admin edits a group type', type: :feature, js: true do
  let!(:group_type) { create :group_type, name: 'Band' }
  let!(:other_group_type) { create :group_type, name: 'Health Visitor' }

  before { log_in create(:admin) }

  it 'updates group type' do
    visit admin_group_types_path

    first('.bi-pencil').click
    fill_in GroupType.human_attribute_name('name'), with: 'NHS Band'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: GroupType.model_name.human))
    expect(group_type.reload.name).to eq 'NHS Band'
  end

  context 'when enter non unique name' do
    it 'does not update group type' do
      visit admin_group_types_path

      first('.bi-pencil').click
      fill_in GroupType.human_attribute_name('name'), with: 'Health Visitor'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: GroupType.model_name.human))

      within_invalid_form_field 'group_type_name' do
        expect(page).to have_content 'has already been taken'
      end

      expect(group_type.reload.name).to eq 'Band'
    end
  end
end
