require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user) { create :user }

  path '/api/v1/users/{id}' do
    get 'get user' do
      tags 'Users'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :include, in: :query, type: :string, required: false, example: 'user_groups'
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:include) { '' }

      response '200', 'Showing user' do
        let(:id) { user.id }

        schema '$ref' => '#/definitions/user_response_with_relationships'

        run_test! do
          parsed_json_data_matches_db_record(user)
        end
      end

      it_behaves_like 'has response unauthorized'

      it_behaves_like 'has response record not found'

      it_behaves_like 'has response unsupported accept header' do
        let(:id) { user.id }
      end
    end
  end
end
