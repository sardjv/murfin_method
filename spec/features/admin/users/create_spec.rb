require 'rails_helper'

describe 'Admin creates a user', type: :feature, js: true do
  let!(:admin) { create :admin }

  let(:first_name) { Faker::Name.first_name }
  let(:new_first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }

  let(:created_user) { User.find_by(email: email) }

  before do
    log_in admin

    visit admin_users_path
    click_link I18n.t('actions.add', model_name: User.model_name.human.titleize)
  end

  context 'auth method is oauth' do
    around do |example|
      ClimateControl.modify AUTH_METHOD: 'oauth' do
        example.run
      end
    end

    it 'creates user with no password' do
      fill_in User.human_attribute_name('first_name'), with: first_name
      fill_in User.human_attribute_name('last_name'), with: last_name
      fill_in User.human_attribute_name('email'), with: email
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.successfully.created', model_name: User.model_name.human))
      expect(User.all.count).to eq 2
    end

    it 'has form without password fields' do
      within 'form.new_user' do
        expect(page).not_to have_content 'Password'
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

    it 'creates user with password' do
      fill_in User.human_attribute_name('first_name'), with: first_name
      fill_in User.human_attribute_name('last_name'), with: last_name
      fill_in User.human_attribute_name('email'), with: email
      fill_in User.human_attribute_name('password'), with: password
      fill_in User.human_attribute_name('password_confirmation'), with: password
      click_button I18n.t('actions.save')

      expect(page).to have_content(I18n.t('notice.successfully.created', model_name: User.model_name.human))
      expect(created_user.valid_password?(password))
      expect(User.all.count).to eq 2
    end

    context 'password does not match confirmation' do
      it 'does not create user and shows form error' do
        fill_in User.human_attribute_name('first_name'), with: first_name
        fill_in User.human_attribute_name('last_name'), with: last_name
        fill_in User.human_attribute_name('email'), with: email
        fill_in User.human_attribute_name('password'), with: password
        fill_in User.human_attribute_name('password_confirmation'), with: "#{password}$"
        click_button I18n.t('actions.save')

        within_invalid_form_field 'user_password_confirmation' do
          expect(page).to have_content "doesn't match Password"
        end
      end
    end

    context 'email already used' do
      let(:email) { Faker::Internet.email }
      let!(:existing_user) { create :user, email: email }

      it 'does not create user' do
        fill_in User.human_attribute_name('first_name'), with: first_name
        fill_in User.human_attribute_name('last_name'), with: last_name
        fill_in User.human_attribute_name('email'), with: email
        click_button I18n.t('actions.save')

        expect(page).to have_content(I18n.t('notice.could_not_be.created', model_name: User.model_name.human))

        within_invalid_form_field 'user_email' do
          expect(page).to have_content 'has already been taken'
        end

        expect(User.all.count).to eq 2
      end
    end
  end
end
