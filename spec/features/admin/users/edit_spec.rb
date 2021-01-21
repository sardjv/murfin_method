require 'rails_helper'

describe 'Admin edits a user', type: :feature, js: true do
  let!(:user) do
    create(:user, first_name: 'Jo',
                  last_name: 'Anne',
                  email: 'joanne@example.com')
  end
  let(:admin) { create :admin }

  let(:password) { Faker::Internet.password }

  before do
    log_in admin
    visit admin_users_path
    first('.bi-pencil').click
  end

  it 'updates user' do
    fill_in User.human_attribute_name('first_name'), with: 'Joanne'
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
    expect(user.reload.first_name).to eq 'Joanne'
  end

  it 'updates user password' do
    fill_in User.human_attribute_name('password'), with: password
    fill_in User.human_attribute_name('password_confirmation'), with: password
    click_button I18n.t('actions.save')

    expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
    expect(user.reload.first_name).to eq 'Joanne'
  end

  context 'when enter non unique email' do
    let!(:existing_user) { create(:user, email: 'john@example.com') }

    it 'does not update user' do
      fill_in User.human_attribute_name('email'), with: 'john@example.com'
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: User.model_name.human))
      expect(user.reload.email).to eq 'joanne@example.com'
    end
  end

  context 'password is too short' do
    let(:password) { '123' }
    it 'shows form error' do
      fill_in User.human_attribute_name('password'), with: password
      fill_in User.human_attribute_name('password_confirmation'), with: password
      click_button I18n.t('actions.save')

      within_invalid_form_field 'user_password' do
        expect(page).to have_content 'is too short (minimum is 6 characters)'
      end
    end
  end
end
