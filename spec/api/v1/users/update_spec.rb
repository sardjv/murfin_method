require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_user) { create :user }

  let(:example_attributes) { Swagger::V1::Users.definitions.dig(:user_attributes, :properties).transform_values { |v| v[:example] } }

  path '/api/v1/users/{id}' do
    patch 'update user' do
      tags 'Users'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :user, in: :body, schema: { '$ref' => '#/definitions/user_patch_params' }

      let(:id) { updated_user.id }

      let(:user) do
        {
          data: {
            type: 'users',
            id: updated_user.id,
            attributes: example_attributes
          }
        }
      end

      context 'authorized' do
        let(:Authorization) { 'Bearer dummy_json_web_token' }

        response '200', 'OK: User updated' do
          schema '$ref' => '#/definitions/user_patch_params'

          run_test! do
            updated_user.reload
            example_attributes.each do |key, value|
              expect(value.to_s).to eq(updated_user.send(key).to_s)
            end
          end
        end

        # user params include not permitted admin_id
        response '400', 'Error: Bad Request' do
          let(:example_attributes_with_admin_id) { example_attributes.merge(admin_id: 123456) }

          let(:user) do
            {
              data: {
                type: 'users',
                attributes: example_attributes_with_admin_id
              }
            }
          end

          schema '$ref' => '#/definitions/error_400'
          run_test!
        end
      end

    end
  end
end
