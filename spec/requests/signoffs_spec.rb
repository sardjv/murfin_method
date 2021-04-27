require 'rails_helper'

RSpec.describe 'Signoffs', type: :request do
  let(:current_user) { create(:user) }
  let(:user_id) { current_user.id }
  before { log_in(current_user) }

  context 'with a signoff' do
    let!(:signoff) { create(:signoff, user_id: user_id) }

    describe 'PUT /signoffs/:id/sign' do
      it 'updates state' do
        put "/signoffs/#{signoff.id}/sign", xhr: true
        expect(response).to have_http_status(:ok)
        assert(signoff.reload.signed?)
      end

      context 'when signoff is another user' do
        let(:user_id) { create(:user).id }

        it 'does not update state' do
          put "/signoffs/#{signoff.id}/sign", xhr: true
          expect(response).to have_http_status(:forbidden)
          refute(signoff.reload.signed?)
        end

        context 'when admin' do
          let(:current_user) { create(:user, admin: true) }

          it 'updates state' do
            put "/signoffs/#{signoff.id}/sign", xhr: true
            expect(response).to have_http_status(:ok)
            assert(signoff.reload.signed?)
          end
        end
      end
    end
  end

  context 'with a signed signoff' do
    let!(:signoff) { create :signoff, :signed, user_id: user_id }

    describe 'PUT /signoffs/:id/revoke' do
      it 'updates state' do
        put "/signoffs/#{signoff.id}/revoke", xhr: true
        expect(response).to have_http_status(:ok)
        assert(signoff.reload.revoked?)
      end

      context 'when signoff is another user' do
        let(:user_id) { create(:user).id }

        it 'does not update state' do
          put "/signoffs/#{signoff.id}/sign", xhr: true
          expect(response).to have_http_status(:forbidden)
          refute(signoff.reload.revoked?)
        end

        context 'when admin' do
          let(:current_user) { create(:user, admin: true) }

          it 'updates state' do
            put "/signoffs/#{signoff.id}/revoke", xhr: true
            expect(response).to have_http_status(:ok)
            assert(signoff.reload.revoked?)
          end
        end
      end
    end
  end
end
