require 'rails_helper'

describe 'Admin log in', type: :feature do
  shared_examples 'updates trackable fields' do
    it 'updates trackable fields' do
      prev_sign_in_count = admin.sign_in_count
      prev_current_sign_in_at = admin.current_sign_in_at
      prev_sign_in_auth_method = admin.current_sign_in_auth_method

      expect(admin.reload.sign_in_count).to eql prev_sign_in_count + 1
      expect(admin.last_sign_in_at).to eql prev_current_sign_in_at
      expect(admin.current_sign_in_at.strftime('%Y-%m-%d %H-%M')).to eql Time.current.strftime('%Y-%m-%d %H-%M')
      expect(admin.last_sign_in_auth_method).to eql prev_sign_in_auth_method
      expect(admin.current_sign_in_auth_method).to eql ENV['AUTH_METHOD']
    end
  end

  context 'via oauth2' do
    let!(:admin) { create :admin }

    around do |example|
      ClimateControl.modify AUTH_METHOD: 'oauth2' do
        example.run
      end
    end

    before do
      log_in admin
      visit admin_dashboard_path
    end

    it 'logs admin in' do
      expect(page).to have_content 'Admin dashboard'
    end

    it 'sets signed cookie' do
      expect(get_me_the_cookie('user_id')).to be_present
    end

    it_behaves_like 'updates trackable fields'
  end

  context 'via form (Devise)' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }
    let!(:admin) { create :admin, :with_password, email: email, password: password }

    around do |example|
      ClimateControl.modify AUTH_METHOD: 'form' do
        example.run
      end
    end

    before do
      visit root_path

      within '.navbar' do
        click_link 'Log in'
      end
    end

    context 'valid email and password' do
      let(:success_message) { 'Signed in successfully.' }

      before do
        within 'form' do
          fill_in 'Email', with: email
          fill_in 'Password', with: password
          click_button 'Log in'
        end
      end

      it 'logs admin in' do
        expect(current_path).to eql admin_dashboard_path

        within '.alert-info' do
          expect(page).to have_content success_message
        end
      end

      it 'sets signed cookie' do
        expect(get_me_the_cookie('user_id')).to be_present
      end

      it_behaves_like 'updates trackable fields'
    end

    context 'invalid password' do
      let(:failure_message) { 'Invalid Email or password.' }

      it 'shows form error' do
        within 'form' do
          fill_in 'Email', with: email
          fill_in 'Password', with: "#{password}$"
          click_button 'Log in'
        end

        within '.alert-danger' do
          expect(page).to have_content failure_message
        end
      end
    end
  end
end

# TODO: spec real log in using VCR
# TODO: missing similar feature specs set for regular user
# TODO: missing log out feature spec
# TODO: via ldap spec
