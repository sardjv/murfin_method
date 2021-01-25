require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'GET admin_dashboard_path' do
    let(:user) do
      create(:user,
             first_name: 'John',
             last_name: 'Smith',
             email: 'john@example.com')
    end
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
