require 'rails_helper'

describe 'Admin creates a user', type: :feature do
  before { log_in create(:admin) }

  it 'creates user' do
    visit admin_users_path

    click_link I18n.t('actions.add', model_name: User.model_name.human)
    fill_in I18n.t('users.labels.first_name'), with: 'Mary'
    fill_in I18n.t('users.labels.last_name'), with: 'Anne'
    fill_in I18n.t('users.labels.email'), with: 'mary@example.com'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.created', model_name: User.model_name.human))
    expect(User.all.count).to eq 2
  end

  context 'when enter non unique email' do
    let!(:existing_user) { create(:user, email: 'john@example.com') }

    it 'does not create user' do
      visit admin_users_path

      click_link I18n.t('actions.add', model_name: User.model_name.human)
      fill_in I18n.t('users.labels.first_name'), with: 'Mary'
      fill_in I18n.t('users.labels.last_name'), with: 'Anne'
      fill_in I18n.t('users.labels.email'), with: 'john@example.com'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: User.model_name.human))
      expect(User.all.count).to eq 2
    end
  end
end
