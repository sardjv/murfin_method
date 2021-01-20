require 'rails_helper'

describe 'Admin log in', type: :feature do

  context 'via oauth2' do
    let!(:admin) { create :admin }

    before do
      stub_env('AUTH_METHOD', 'oauth2')

      log_in admin
    end

    it 'logs admin in' do
      visit admin_dashboard_path

      expect(page).to have_content 'Admin dashboard'
    end
  end

  context 'via form' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }
    let!(:admin) { create :admin, :with_password, email: email, password: password }

    before do
      stub_env('AUTH_METHOD', 'form')

      visit root_path

      within '.navbar' do
        click_link 'Log in'
      end
    end

    context 'valid email and password' do
      it 'logs admin in' do
        within 'form' do
          fill_in 'Email', with: email
          fill_in 'Password', with: password
          click_button 'Log in'
        end
        expect(current_path).to eql admin_dashboard_path

        within '.alert-info' do
          expect(page).to have_content 'Signed in successfully.'
        end
      end
    end

    context 'invalid password' do
      it 'shows form error' do
        within 'form' do
          fill_in 'Email', with: email
          fill_in 'Password', with: password + '$'
          click_button 'Log in'
        end

        within '.alert-danger' do
          expect(page).to have_content 'Invalid Email or password.'
        end
      end
    end

  end
end

# TODO missing similar feature specs set for regular user
