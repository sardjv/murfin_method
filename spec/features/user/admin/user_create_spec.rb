require 'rails_helper'

describe 'Admin creates a user', type: :feature do
  let(:admin) do
    create(:user, first_name: 'John',
                  last_name: 'Smith',
                  email: 'john@example.com',
                  admin: true)
  end

  it 'creates user' do
    visit admin_users_path

    click_link I18n.t('users.add')
    fill_in I18n.t('users.labels.first_name'), with: 'Mary'
    fill_in I18n.t('users.labels.last_name'), with: 'Anne'
    fill_in I18n.t('users.labels.email'), with: 'mary@example.com'
    click_button I18n.t('users.save')

    expect(page).to have_content(I18n.t('users.notice.successfully.created'))
    expect(User.all.count).to eq 2
  end

  context 'when enter non unique email' do
    it 'does not create user' do
      visit admin_users_path

      click_link I18n.t('users.add')
      fill_in I18n.t('users.labels.first_name'), with: 'Mary'
      fill_in I18n.t('users.labels.last_name'), with: 'Anne'
      fill_in I18n.t('users.labels.email'), with: 'john@example.com'
      click_button I18n.t('users.save')

      expect(page).to have_content(I18n.t('users.notice.could_not_be.created'))
      expect(User.all.count).to eq 1
    end
  end
end
