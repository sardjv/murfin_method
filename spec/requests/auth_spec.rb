require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  let!(:admin) { create :admin }

  context 'via oauth2' do
    around do |example|
      ClimateControl.modify AUTH_METHOD: 'oauth2' do
        example.run
      end
    end

    describe 'GET admin_dashboard_path' do
      context 'when authenticated' do
        before do
          log_in(admin)
        end

        it 'returns http success' do
          get admin_dashboard_path
          expect(response).to have_http_status(:success)
        end
      end

      context 'when not authenticated' do
        it 'redirects to root path' do
          get admin_dashboard_path
          expect(response).to redirect_to root_path
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
      context 'when authenticated' do
        before do
          log_in(admin)
        end

        it 'returns http success' do
          get admin_dashboard_path
          expect(response).to have_http_status(:success)
        end
      end

      context 'when not authenticated' do
        it 'redirects to login path' do
          get admin_dashboard_path
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
