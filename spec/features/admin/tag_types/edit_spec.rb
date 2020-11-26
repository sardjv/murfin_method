require 'rails_helper'

describe 'Admin edits a tag type', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Band')
  end
  let!(:other_tag_type) do
    create(:tag_type, name: 'Health Visitor')
  end
  before { log_in create(:admin) }

  it 'updates tag type' do
    visit admin_tag_types_path

    first('.bi-pencil').click
    fill_in I18n.t('tag_types.labels.name'), with: 'NHS Band'
    click_button I18n.t('tag_types.save')

    expect(page).to have_content(I18n.t('tag_types.notice.successfully.updated'))
    expect(tag_type.reload.name).to eq 'NHS Band'
  end

  context 'when enter non unique name' do
    it 'does not update tag type' do
      visit admin_tag_types_path

      first('.bi-pencil').click
      fill_in I18n.t('tag_types.labels.name'), with: 'Health Visitor'
      click_button I18n.t('tag_types.save')

      expect(page).to have_content(I18n.t('tag_types.notice.could_not_be.updated'))
      expect(tag_type.reload.name).to eq 'Band'
    end
  end
end
