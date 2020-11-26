require 'rails_helper'

describe 'Admin creates a tag', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Band')
  end
  before { log_in create(:admin) }

  it 'creates tag' do
    visit admin_tag_types_path

    within('.card-header') do
      first('.bi-plus').click
    end

    fill_in I18n.t('tags.labels.name'), with: 'Band 1'
    click_button I18n.t('tags.save')

    expect(page).to have_content(I18n.t('tags.notice.successfully.created'))
    expect(Tag.all.count).to eq 1
  end

  context 'when enter non unique name' do
    let!(:tag) do
      create(:tag, tag_type: tag_type, name: 'Band 1')
    end
    it 'does not create tag' do
      visit admin_tag_types_path

      within('.card-header') do
        first('.bi-plus').click
      end
      fill_in I18n.t('tags.labels.name'), with: 'Band 1'
      click_button I18n.t('tags.save')

      expect(page).to have_content(I18n.t('tags.notice.could_not_be.created'))
      expect(Tag.all.count).to eq 1
    end
  end
end
