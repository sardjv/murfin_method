require 'rails_helper'

describe 'Admin adds a user to a group', type: :feature, js: true do
  let(:user) do
    create(:user)
  end
  let!(:group_type) do
    create(:group_type, name: 'Band')
  end
  let!(:band1_group) do
    create(:user_group, group_type: group_type, name: 'Band 1')
  end
  let!(:band2_group) do
    create(:user_group, group_type: group_type, name: 'Band 2')
  end

  before { log_in create(:admin) }

  it 'updates user group' do
    visit edit_admin_user_path(user)

    expect(page).to have_bootstrap_select('Band', options: ['', 'Band 1', 'Band 2'])
    bootstrap_select 'Band 2', from: 'Band'
    click_button I18n.t('users.save')

    expect(page).to have_content(I18n.t('users.notice.successfully.updated'))
    expect(user.user_groups.first.name).to eq 'Band 2'
  end
end
