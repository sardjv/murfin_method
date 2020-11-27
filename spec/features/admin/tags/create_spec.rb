require 'rails_helper'

describe 'Admin creates a tag', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Patient Contact')
  end
  before { log_in create(:admin) }

  it 'creates tag' do
    visit admin_tag_types_path

    within('.card-header') do
      first('.bi-plus').click
    end

    fill_in Tag.human_attribute_name('name'), with: '1'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: Tag.model_name.human))
    expect(Tag.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:tag) do
      create(:tag, tag_type: tag_type, name: '1')
    end
    it 'does not create tag' do
      visit admin_tag_types_path

      within('.card-header') do
        first('.bi-plus').click
      end
      fill_in Tag.human_attribute_name('name'), with: '1'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: Tag.model_name.human))
      expect(Tag.all.count).to eq 1
    end
  end
end
