require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user) { create :user }

  path '/api/v1/users/{id}' do
    delete 'destroys user' do
      tags 'Users'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:id) { user.id }

      context 'authorized' do
        response '204', 'OK: No Content' do
          run_test! do
            expect(User.exists?(user.id)).to eql false
          end
        end

        response '404', 'Record not found' do # TODO refactor to shared example
          let(:id) { 12345 }
          run_test!
        end

        context 'user for destroy is admin' do
          let!(:user) { create :user, admin: true }

          response '423', 'Error: Record Locked' do
            run_test! do
              expect(user.reload).not_to be_destroyed
            end
          end
        end
      end
    end
  end
end
