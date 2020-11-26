require 'rails_helper'

describe 'Admin edits a tag', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Band')
  end
  let!(:band1_tag) do
    create(:tag, tag_type: tag_type, name: 'Band 1')
  end
  let!(:band2_tag) do
    create(:tag, tag_type: tag_type, name: 'Band 2')
  end

  before { log_in create(:admin) }

  it 'updates tag' do
    visit admin_tag_types_path

    page.click_on('Bands')
    within('.card-body') do
      first('.bi-pencil').click
    end
    fill_in I18n.t('tags.labels.name'), with: 'NHS Band 1'
    click_button I18n.t('tags.save')

    expect(page).to have_content(I18n.t('tags.notice.successfully.updated'))
    expect(band1_tag.reload.name).to eq 'NHS Band 1'
  end

  context 'when enter non unique name' do
    it 'does not update tag' do
      visit admin_tag_types_path

      page.click_on('Bands')
      within('.card-body') do
        first('.bi-pencil').click
      end
      fill_in I18n.t('tags.labels.name'), with: 'Band 2'
      click_button I18n.t('tags.save')

      expect(page).to have_content(I18n.t('tags.notice.could_not_be.updated'))
      expect(band1_tag.reload.name).to eq 'Band 1'
    end
  end
end
