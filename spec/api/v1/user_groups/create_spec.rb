require 'swagger_helper'

describe Api::V1::UserGroupResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_user_group) { UserGroup.find_by(name: user_group_name) }
  let(:user_group_name) { Faker::Lorem.word }
  let!(:group_type) { create :group_type }

  let(:valid_attributes) do
    {
      name: user_group_name,
      group_type_id: group_type.id
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/user_groups' do
    post 'create user group' do
      tags 'UserGroups'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :user_group, in: :body, schema: { '$ref' => '#/definitions/user_group_post_params' }

      let(:user_group) do
        {
          data: {
            type: 'user_groups',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'User Group created' do
        schema '$ref' => '#/definitions/user_group_post_params'

        run_test! do
          parsed_json_data_matches_db_record(created_user_group)
        end
      end

      context 'name not unique in group type scope' do
        let!(:existing_user_group) { create :user_group, name: user_group_name, group_type_id: group_type.id }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'has already been taken' }
          let(:error_detail) { 'name - has already been taken' }
        end
      end

      context 'group type id missing' do
        let(:attributes) do
          {
            name: user_group_name,
            group_type_id: 54_321
          }
        end

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'group_type - must exist' }
        end
      end
    end
  end
end
