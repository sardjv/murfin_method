require 'rails_helper'

RSpec.describe 'Signoffs', type: :request do
  before do
    log_in(build(:user))
  end

  context 'with a signoff' do
    let!(:signoff) { create(:signoff) }

    describe 'PUT /signoffs/:id/sign' do
      it 'updates state' do
        put "/signoffs/#{signoff.id}/sign", xhr: true
        expect(response).to have_http_status(:ok)
        assert(signoff.reload.signed?)
      end
    end
  end

  context 'with a signed signoff' do
    let!(:signoff) { create(:signed_signoff) }

    describe 'PUT /signoffs/:id/revoke' do
      it 'updates state' do
        put "/signoffs/#{signoff.id}/revoke", xhr: true
        expect(response).to have_http_status(:ok)
        assert(signoff.reload.revoked?)
      end
    end
  end
end
