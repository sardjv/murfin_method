require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  let(:current_user) { create(:user) }
  before do
    log_in(current_user)
  end

  describe 'GET /plans/new' do
    it 'returns http ok' do
      get '/plans/new'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /plans' do
    context 'with valid params' do
      let(:start_date) { Date.today }
      let(:user_id) { current_user.id }
      let(:params) do
        {
          plan: {
            start_date: start_date,
            user_id: user_id
          }
        }
      end

      it 'redirects to the index' do
        post '/plans', params: params
        expect(response).to redirect_to(plans_url)
      end

      it 'creates a new plan' do
        expect { post '/plans', params: params }.to change { Plan.count }.by(1)
      end

      it 'persists values' do
        post '/plans', params: params
        expect(Plan.last.start_date).to eq(start_date)
        expect(Plan.last.user_id).to eq(user_id)
      end
    end
  end

  describe 'GET /plans/:id/edit' do
    context 'with a plan' do
      let!(:plan) { create(:plan) }

      it 'returns http ok' do
        get "/plans/#{plan.id}/edit"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /plans/:id' do
    context 'with a plan' do
      let!(:plan) { create(:plan) }
      let(:new_start_date) { plan.end_date - 10.days }
      let(:params) do
        {
          plan: {
            start_date: new_start_date
          }
        }
      end

      it 'redirects to the edit view' do
        put "/plans/#{plan.id}", params: params
        expect(response).to redirect_to(edit_plan_url(plan))
      end

      it 'updates plan' do
        put "/plans/#{plan.id}", params: params
        expect(plan.reload.start_date).to eq(new_start_date)
      end
    end
  end

  describe 'DELETE /plans/:id' do
    context 'with a plan' do
      let!(:plan) { create(:plan) }

      it 'redirects to the index' do
        delete "/plans/#{plan.id}"
        expect(response).to redirect_to(plans_url)
      end

      it 'deletes plan' do
        expect { delete "/plans/#{plan.id}" }.to change { Plan.count }.by(-1)
      end
    end
  end
end
