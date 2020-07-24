require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    context 'with valid params' do
      let(:note) { build(:note) }
      let(:content) { note.content }
      let(:start_time) { note.start_time }
      let(:end_time) { note.end_time }
      let(:params) do
        {
          note: {
            content: content,
            start_time: start_time,
            end_time: end_time
          }
        }
      end

      it 'returns http success' do
        post '/notes', params: params
        expect(response).to have_http_status(:success)
      end

      it 'creates a new note' do
        expect { post '/notes', params: params }.to change { Note.count }.by(1)
      end

      it 'persists values' do
        post '/notes', params: params
        expect(Note.last.content).to eq(content)
      end
    end
  end
end
