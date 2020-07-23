require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    it 'returns http success' do
      post '/notes'
      expect(response).to have_http_status(:success)
    end
  end
end
