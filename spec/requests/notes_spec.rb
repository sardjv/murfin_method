require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'POST /notes' do
    context 'with valid params' do
      let(:note) { build(:note) }
      let(:content) { note.content }
      let(:start_time) { note.start_time }
      let(:state) { 'action' }

      let(:params) do
        {
          note: {
            content: content,
            start_time: start_time,
            state: state
          }
        }
      end

      it 'returns http created' do
        post '/notes', params: params, xhr: true
        expect(response).to have_http_status(:created)
      end

      it 'creates a new note' do
        expect { post '/notes', params: params, xhr: true }.to change { Note.count }.by(1)
      end

      it 'persists values' do
        post '/notes', params: params, xhr: true
        expect(Note.last.content).to eq(content)
        expect(Note.last.start_time).to eq(start_time)
        expect(Note.last.state).to eq(state)
      end
    end
  end
end
