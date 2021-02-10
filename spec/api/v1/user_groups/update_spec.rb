require 'swagger_helper'

describe Api::V1::UserGroupResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_user_group) { create :user_group }
  let!(:group_type) { create :group_type }

  let(:valid_attributes) do
    {
      name: Faker::Lorem.word,
      group_type_id: group_type.id
    }
  end

  path '/api/v1/user_groups/{id}' do
    patch 'update user group' do
      tags 'UserGroups'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :user_group, in: :body, schema: { '$ref' => '#/definitions/user_group_patch_params' }

      let(:id) { updated_user_group.id }
      let(:attributes) { valid_attributes }

      let(:user_group) do
        {
          data: {
            type: 'user_groups',
            id: updated_user_group.id,
            attributes: attributes
          }
        }
      end

      context 'authorized' do
        let(:Authorization) { 'Bearer dummy_json_web_token' }

        response '200', 'OK: User Group updated' do
          schema '$ref' => '#/definitions/user_group_patch_params'

          run_test! do
            parsed_json_data_matches_db_record(updated_user_group)
          end
        end

        context 'group type does not exist' do
          let(:attributes) { valid_attributes.merge({ group_type_id: 9_876_543 }) }

          response '422', 'Invalid request' do
            schema '$ref' => '#/definitions/error_422'
            run_test!
          end
        end
      end
    end
  end
end
