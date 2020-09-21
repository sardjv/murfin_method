require 'rails_helper'

describe 'Admin destroys a user', type: :feature, js: true do
  let(:admin) do
    create(:user, first_name: 'John',
                  last_name: 'Smith',
                  email: 'john@example.com',
                  admin: true)
  end
  let!(:user) do
    create(:user, first_name: 'Jo',
                  last_name: 'Anne',
                  email: 'joanne@example.com')
  end

  it 'creates user' do
    visit admin_users_path

    accept_confirm do
      first('.bi-trash').click
    end

    expect(page).to have_content(I18n.t('users.notice.successfully.destroyed'))
    expect(User.all.count).to eq 1
  end
end
