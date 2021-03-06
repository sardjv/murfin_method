require 'rails_helper'

describe 'Admin destroys a tag', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Patient Contact')
  end
  let!(:tag) do
    create(:tag, tag_type: tag_type, name: '1')
  end
  before { log_in create(:admin) }

  it 'destroys user' do
    visit admin_tag_types_path

    page.click_on('Patient Contact')
    within('.card-body') do
      accept_confirm do
        first('.bi-trash').click
      end
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: Tag.model_name.human))
    expect(Tag.all.count).to eq 0
  end
end
