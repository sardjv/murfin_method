require 'rails_helper'

describe 'Admin destroys a user group', type: :feature, js: true do
  let(:admin) do
    create(:admin, first_name: 'John',
                   last_name: 'Smith',
                   email: 'john@example.com')
  end
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:user_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end

  it 'destroys user' do
    visit admin_group_types_path

    page.click_on('Bands')
    within('.card-body') do
      accept_confirm do
        first('.bi-trash').click
      end
    end

    expect(page).to have_content(I18n.t('user_groups.notice.successfully.destroyed'))
    expect(UserGroup.all.count).to eq 0
  end
end
