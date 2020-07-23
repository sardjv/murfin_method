require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    context 'with valid params' do
      it 'returns http success' do
        post '/notes'
        expect(response).to have_http_status(:success)
      end

      it 'creates a new note' do
        expect { post '/notes' }.to change { Note.count }.by(1)
      end
    end
  end
end
