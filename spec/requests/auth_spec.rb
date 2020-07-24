require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'GET admin_dashboard_path' do
    context 'when authenticated' do
      # Users are authenticated by default in specs via spec/support/secured_with_oauth_override.rb.
      let(:session) { Class.new.extend(SecuredWithOauth).session }

      it 'returns http success' do
        get admin_dashboard_path
        expect(response).to have_http_status(:success)
      end

      it 'creates a user' do
        expect { get admin_dashboard_path }.to change { User.count }.by(1)
      end

      it 'sets the user name and email' do
        get admin_dashboard_path
        expect(User.last.first_name).to eq(session.dig(:userinfo, 'extra', 'raw_info', 'given_name'))
        expect(User.last.last_name).to eq(session.dig(:userinfo, 'extra', 'raw_info', 'family_name'))
        expect(User.last.email).to eq(session.dig(:userinfo, 'info', 'email'))
      end
    end

    context 'when not authenticated' do
      before do
        module SecuredWithOauth
          def session; end
        end
      end

      it 'redirects to root_path' do
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
