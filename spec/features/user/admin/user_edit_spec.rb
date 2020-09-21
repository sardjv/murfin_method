require 'rails_helper'

describe 'Admin edit a user', type: :feature, js: true do
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

    first('.bi-pencil').click
    fill_in I18n.t('users.labels.first_name'), with: 'Joanne'
    click_button I18n.t('users.save')

    expect(page).to have_content(I18n.t('users.notice.successfully.updated'))
    expect(user.reload.first_name).to eq 'Joanne'
  end

  context 'when enter non unique email' do
    it 'does not update user' do
      visit admin_users_path

      first('.bi-pencil').click
      fill_in I18n.t('users.labels.email'), with: 'john@example.com'
      click_button I18n.t('users.save')

      expect(page).to have_content(I18n.t('users.notice.could_not_be.updated'))
      expect(user.reload.email).to eq 'joanne@example.com'
    end
  end
end
