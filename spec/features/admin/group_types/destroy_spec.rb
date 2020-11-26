require 'rails_helper'

describe 'Admin destroys a group type', type: :feature, js: true do
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end

  before { log_in create(:admin) }

  it 'destroys group type' do
    visit admin_group_types_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: GroupType.model_name.human))
    expect(GroupType.all.count).to eq 0
  end
end
