require 'rails_helper'

describe 'Admin destroys a user', type: :feature, js: true do
  let!(:user) do
    create(:user, first_name: 'Jo',
                  last_name: 'Anne',
                  email: 'joanne@example.com')
  end

  before { log_in create(:admin) }

  it 'destroys user' do
    visit admin_users_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('users.notice.successfully.destroyed'))
    expect(User.all.count).to eq 1
  end
end
