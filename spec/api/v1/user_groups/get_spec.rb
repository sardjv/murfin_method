require 'swagger_helper'

describe Api::V1::UserGroupResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user_group) { create :user_group }

  path '/api/v1/user_groups/{id}' do
    get 'get user group' do
      tags 'UserGroups'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let!(:id) { user_group.id }

      response '200', 'Showing tag type' do
        schema '$ref' => '#/definitions/user_group_response'

        run_test! do
          parsed_json_data_matches_db_record(user_group)
        end
      end

      response '404', 'Record not found' do
        schema '$ref' => '#/definitions/error_404'

        let(:id) { 111_222 }

        run_test!
      end

      response '406', 'Unsupported accept header' do
        schema '$ref' => '#/definitions/error_406'

        let(:Accept) { 'application/json' }
        run_test!
      end
    end
  end
end
