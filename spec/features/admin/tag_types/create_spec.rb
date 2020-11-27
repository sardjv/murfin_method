require 'rails_helper'

describe 'Admin creates a tag type', type: :feature, js: true do
  before { log_in create(:admin) }
  let(:name) { 'Patient Contacts' }

  it 'creates tag type' do
    visit admin_tag_types_path

    click_link I18n.t('actions.add', model_name: TagType.model_name.human)
    fill_in I18n.t('tag_types.labels.name'), with: name
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: TagType.model_name.human))
    expect(TagType.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:tag_type) { create(:tag_type, name: name) }
    it 'does not create tag type' do
      visit admin_tag_types_path

      click_link I18n.t('actions.add', model_name: TagType.model_name.human)
      fill_in I18n.t('tag_types.labels.name'), with: name
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: TagType.model_name.human))
      expect(TagType.all.count).to eq 1
    end
  end
end
