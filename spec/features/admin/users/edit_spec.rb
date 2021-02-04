require 'rails_helper'

describe 'Admin edits a user', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:first_name) { Faker::Name.first_name }
  let(:new_first_name) { Faker::Name.unique.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let!(:user) { create :user, first_name: first_name, last_name: last_name, email: email }

  before do
    log_in admin

    visit admin_users_path
    within "#user_#{user.id}" do
      first('.bi-pencil').click
    end
  end

  context 'auth method is oauth' do
    around do |example|
      ClimateControl.modify AUTH_METHOD: 'oauth' do
        example.run
      end
    end

    it 'updates user' do
      fill_in User.human_attribute_name('first_name'), with: new_first_name
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
      expect(user.reload.first_name).to eq new_first_name
    end

    it 'has form without password fields' do
      within 'form.edit_user' do
        expect(page).not_to have_content 'Password'
      end
    end

    context 'when enter non unique email' do
      let(:used_email) { Faker::Internet.email }
      let!(:existing_user) { create :user, email: used_email }

      it 'does not update user' do
        fill_in User.human_attribute_name('email'), with: used_email
        click_button I18n.t('actions.save')

        expect(page).to have_content(I18n.t('notice.could_not_be.updated', model_name: User.model_name.human))
        expect(user.reload.email).to eq email
      end
    end
  end

  context 'auth method is form' do
    let(:password) { Faker::Internet.password }

    around do |example|
      ClimateControl.modify AUTH_METHOD: 'form' do
        example.run
      end
    end

    it 'updates user password' do
      fill_in User.human_attribute_name('password'), with: password
      fill_in User.human_attribute_name('password_confirmation'), with: password
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.successfully.updated', model_name: User.model_name.human))
      expect(user.valid_password?(password))
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
end
