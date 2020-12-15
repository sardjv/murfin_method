require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  context 'when logged in' do
    let(:current_user) { create(:user) }
    before do
      log_in(current_user)
    end

    describe 'GET /plans' do
      it 'returns http ok' do
        get '/plans'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /plans/new' do
      it 'returns http ok' do
        get '/plans/new'
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /plans' do
      context 'with valid params' do
        let(:start_date) { Time.zone.today }
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

        context 'with a different user_id' do
          let(:user_id) { create(:user).id }

          context 'when an admin' do
            let(:current_user) { create(:user, admin: true) }

            it 'creates a new plan' do
              expect { post '/plans', params: params }.to change { Plan.count }.by(1)
            end

            it 'persists values' do
              post '/plans', params: params
              expect(Plan.last.user_id).to eq(user_id)
            end
          end

          context 'when not an admin' do
            it 'is forbidden' do
              post '/plans', params: params
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end

            it 'does not create a plan' do
              expect { post '/plans', params: params }.not_to change(Plan, :count)
            end
          end
        end
      end
    end

    describe 'GET /plans/:id/edit' do
      context 'with a plan' do
        let!(:plan) { create(:plan, user_id: user_id) }
        let(:user_id) { current_user.id }

        it 'returns http ok' do
          get "/plans/#{plan.id}/edit"
          expect(response).to have_http_status(:ok)
        end

        context 'with a different user_id' do
          let(:user_id) { create(:user).id }

          context 'when a signoff' do
            let!(:plan) { create(:plan, user_id: user_id, signoffs: [create(:signoff, user: current_user)]) }

            it 'returns http ok' do
              get "/plans/#{plan.id}/edit"
              expect(response).to have_http_status(:ok)
            end
          end

          context 'when an admin' do
            let(:current_user) { create(:user, admin: true) }

            it 'returns http ok' do
              get "/plans/#{plan.id}/edit"
              expect(response).to have_http_status(:ok)
            end
          end

          context 'when not an admin' do
            it 'is forbidden' do
              get "/plans/#{plan.id}/edit"
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end
          end
        end
      end
    end

    describe 'PUT /plans/:id' do
      context 'with a plan' do
        let!(:plan) { create(:plan, user_id: user_id, start_date: old_start_date) }
        let(:user_id) { current_user.id }
        let(:old_start_date) { Time.zone.today - 10.days }
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

        context 'with a different user_id' do
          let(:user_id) { create(:user).id }

          context 'when a signoff' do
            let!(:plan) { create(:plan, user_id: user_id, signoffs: [create(:signoff, user: current_user)]) }

            it 'is forbidden' do
              put "/plans/#{plan.id}", params: params
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end
          end

          context 'when an admin' do
            let(:current_user) { create(:user, admin: true) }

            it 'redirects to the edit view' do
              put "/plans/#{plan.id}", params: params
              expect(response).to redirect_to(edit_plan_url(plan))
            end

            it 'updates plan' do
              put "/plans/#{plan.id}", params: params
              expect(plan.reload.start_date).to eq(new_start_date)
            end
          end

          context 'when not an admin' do
            it 'is forbidden' do
              put "/plans/#{plan.id}", params: params
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end

            it 'does not update plan' do
              put "/plans/#{plan.id}", params: params
              expect(plan.reload.start_date).to eq(old_start_date)
            end
          end
        end
      end
    end

    describe 'DELETE /plans/:id' do
      context 'with a plan' do
        let!(:plan) { create(:plan, user_id: user_id) }
        let(:user_id) { current_user.id }

        it 'redirects to the index' do
          delete "/plans/#{plan.id}"
          expect(response).to redirect_to(plans_url)
        end

        it 'deletes plan' do
          expect { delete "/plans/#{plan.id}" }.to change { Plan.count }.by(-1)
        end

        context 'with a different user_id' do
          let(:user_id) { create(:user).id }

          context 'when a signoff' do
            let!(:plan) { create(:plan, user_id: user_id, signoffs: [create(:signoff, user: current_user)]) }

            it 'is forbidden' do
              delete "/plans/#{plan.id}"
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end
          end

          context 'when an admin' do
            let(:current_user) { create(:user, admin: true) }

            it 'redirects to the index' do
              delete "/plans/#{plan.id}"
              expect(response).to redirect_to(plans_url)
            end

            it 'deletes plan' do
              expect { delete "/plans/#{plan.id}" }.to change { Plan.count }.by(-1)
            end
          end

          context 'when not an admin' do
            it 'is forbidden' do
              delete "/plans/#{plan.id}"
              redirect_to url: root_path, alert: I18n.t('notice.forbidden')
            end

            it 'does not delete plan' do
              expect { delete "/plans/#{plan.id}" }.not_to change(Plan, :count)
            end
          end
        end
      end
    end
  end

  context 'when not logged in' do
    describe 'GET /plans' do
      it 'redirects to root' do
        get '/plans'
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET /plans/new' do
      it 'redirects to root' do
        get '/plans/new'
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'POST /plans' do
      context 'with valid params' do
        let(:start_date) { Time.zone.today }
        let(:params) do
          {
            plan: {
              start_date: start_date,
              user_id: create(:user).id
            }
          }
        end

        it 'redirects to root' do
          post '/plans', params: params
          expect(response).to redirect_to(root_url)
        end

        it 'does not create a plan' do
          expect { post '/plans', params: params }.not_to change(Plan, :count)
        end
      end
    end

    describe 'GET /plans/:id/edit' do
      context 'with a plan' do
        let!(:plan) { create(:plan) }

        it 'redirects to root' do
          get "/plans/#{plan.id}/edit"
          expect(response).to redirect_to(root_url)
        end
      end
    end

    describe 'PUT /plans/:id' do
      context 'with a plan' do
        let!(:plan) { create(:plan, start_date: old_start_date) }
        let(:old_start_date) { Time.zone.today - 10.days }
        let(:new_start_date) { plan.end_date - 10.days }
        let(:params) do
          {
            plan: {
              start_date: new_start_date
            }
          }
        end

        it 'redirects to root' do
          put "/plans/#{plan.id}", params: params
          expect(response).to redirect_to(root_url)
        end

        it 'does not update plan' do
          put "/plans/#{plan.id}", params: params
          expect(plan.reload.start_date).to eq(old_start_date)
        end
      end
    end

    describe 'DELETE /plans/:id' do
      context 'with a plan' do
        let!(:plan) { create(:plan) }

        it 'redirects to root' do
          delete "/plans/#{plan.id}"
          expect(response).to redirect_to(root_url)
        end

        it 'does not delete plan' do
          expect { delete "/plans/#{plan.id}" }.not_to change(Plan, :count)
        end
      end
    end
  end
end
