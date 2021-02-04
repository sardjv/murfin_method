require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user) { create :user }

  path '/api/v1/users/{id}' do
    get 'get user' do
      tags 'Users'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let!(:id) { user.id }

      response '200', 'Showing user' do
        schema '$ref' => '#/definitions/user_response'

        run_test! do
          parsed_json_data_matches_db_record(user)
        end
      end

      response '404', 'Record not found' do # TODO: refactor to shared example
        let(:id) { 12_345 }
        schema '$ref' => '#/definitions/error_404'
        run_test!
      end

      response '406', 'Unsupported accept header' do # TODO: refactor to shared example
        let(:Accept) { 'application/json' }
        schema '$ref' => '#/definitions/error_406'
        run_test!
      end
    end
  end
end
