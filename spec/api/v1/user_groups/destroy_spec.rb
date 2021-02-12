require 'swagger_helper'

describe Api::V1::UserGroupResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user_group) { create :user_group }

  path '/api/v1/user_groups/{id}' do
    delete 'destroy user group' do
      tags 'UserGroups'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:id) { user_group.id }

      response '204', 'OK: No Content' do
        run_test! do
          refute(UserGroup.exists?(user_group.id))
        end
      end

      response '404', 'Record not found' do
        schema '$ref' => '#/definitions/error_404'

        let(:id) { 54_321 }

        run_test!
      end
    end
  end
end
