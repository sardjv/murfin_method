require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  context 'via oauth2' do
    around do |example|
      ClimateControl.modify AUTH_METHOD: 'oauth2' do
        example.run
      end
    end

    describe 'GET admin_dashboard_path' do
      let(:user) { create :user, first_name: 'John', last_name: 'Smith', email: 'john@example.com' }

      context 'when authenticated' do
        before do
          log_in(user)
        end

        it 'returns http success' do
          get admin_dashboard_path
          expect(response).to have_http_status(:success)
        end

        it 'sets the user name and email' do
          get admin_dashboard_path
          expect(User.last.first_name).to eq('John')
          expect(User.last.last_name).to eq('Smith')
          expect(User.last.email).to eq('john@example.com')
        end
      end

      context 'when not authenticated' do
        it 'redirects to root_path' do
          get admin_dashboard_path
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  context 'via form' do
    around do |example|
      ClimateControl.modify AUTH_METHOD: 'form' do
        example.run
      end
    end

    describe 'GET admin_dashboard_path' do
      let(:user) { create :user }

      context 'when authenticated' do
        before do
          log_in(user)
        end

        it 'returns http success' do
          get admin_dashboard_path
          expect(response).to have_http_status(:success)
        end
      end

      context 'when not authenticated' do
        it 'redirects to root_path' do
          get admin_dashboard_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
