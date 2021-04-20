require 'rails_helper'

RSpec.describe 'ApiUsers', type: :request do
  before do
    log_in(current_user)
  end

  describe 'GET /admin/api_users' do
    context 'when user logged in' do
      let(:current_user) { create(:user) }
      it 'is forbidden' do
        get '/admin/api_users'
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'You are not authorized to perform this action!'
      end
    end
    context 'when admin logged in' do
      let(:current_user) { create(:admin) }
      it 'returns http ok' do
        get '/admin/api_users'
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
