require 'rails_helper'

describe 'Admin destroys a tag type', type: :feature, js: true do
  let!(:tag_type) do
    create(:tag_type, name: 'Band')
  end

  before { log_in create(:admin) }

  it 'destroys tag type' do
    visit admin_tag_types_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: TagType.model_name.human))
    expect(TagType.all.count).to eq 0
  end
end
