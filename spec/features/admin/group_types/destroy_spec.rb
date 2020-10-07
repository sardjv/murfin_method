require 'rails_helper'

describe 'Admin destroys a group type', type: :feature, js: true do
  let(:admin) do
    create(:admin, first_name: 'John',
                   last_name: 'Smith',
                   email: 'john@example.com')
  end
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end

  it 'destroys group type' do
    visit admin_group_types_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('group_types.notice.successfully.destroyed'))
    expect(GroupType.all.count).to eq 0
  end
end
