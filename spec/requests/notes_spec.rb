require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(userinfo: mock_valid_auth_hash(build(:user)))
  end

  describe 'GET /notes/new' do
    context 'with valid params' do
      let(:start_time) { DateTime.now }
      let(:params) do
        {
          note: {
            start_time: start_time
          }
        }
      end

      it 'returns http ok' do
        get '/notes/new', params: params, xhr: true
        expect(response).to have_http_status(:ok)
      end
    end
  end

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

  describe 'GET /notes/:id/edit' do
    context 'with a note' do
      let!(:note) { create(:note) }

      it 'returns http ok' do
        get "/notes/#{note.id}/edit", xhr: true
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /notes/:id' do
    context 'with a note' do
      let!(:note) { create(:note) }
      let(:new_content) { Faker::Lorem.sentences.to_s }
      let(:params) do
        {
          'note' => {
            'content' => new_content
          }
        }
      end

      it 'returns http ok' do
        put "/notes/#{note.id}", params: params, xhr: true
        expect(response).to have_http_status(:ok)
      end

      it 'updates note' do
        put "/notes/#{note.id}", params: params, xhr: true
        expect(note.reload.content).to eq(new_content)
      end
    end
  end

  describe 'DELETE /notes/:id' do
    context 'with a note' do
      let!(:note) { create(:note) }

      it 'returns http no_content' do
        delete "/notes/#{note.id}", xhr: true
        expect(response).to have_http_status(:no_content)
      end

      it 'deletes note' do
        expect { delete "/notes/#{note.id}", xhr: true }.to change { Note.count }.by(-1)
      end
    end
  end
end
