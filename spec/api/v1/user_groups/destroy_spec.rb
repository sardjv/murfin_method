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

      response '204', 'OK: No Content' do
        let(:id) { user_group.id }

        run_test! do
          refute(UserGroup.exists?(user_group.id))
        end
      end

      it_behaves_like 'has response record not found'
    end
  end
end
