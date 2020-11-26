require 'rails_helper'

describe 'Admin destroys a user group', type: :feature, js: true do
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:user_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end
  before { log_in create(:admin) }

  it 'destroys user' do
    visit admin_group_types_path

    page.click_on('Bands')
    within('.card-body') do
      accept_confirm do
        first('.bi-trash').click
      end
    end

    expect(page).to have_content(I18n.t('notice.successfully.destroyed', model_name: UserGroup.model_name.human))
    expect(UserGroup.all.count).to eq 0
  end
end
