require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_user) { create :user }

  let(:example_attributes) do
    Swagger::V1::Users.definitions.dig(:user_attributes_without_admin, :properties).transform_values do |v|
      v[:example]
    end
  end

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
          schema '$ref' => '#/definitions/user_patch_params_without_password'

          run_test! do
            updated_user.reload
            example_attributes.each do |key, value|
              expect(value.to_s).to eq(updated_user.send(key).to_s)
            end
          end
        end

        context 'user attributes contain password' do
          let(:password) { Faker::Internet.password }

          let(:user) do
            {
              data: {
                type: 'users',
                id: updated_user.id,
                attributes: example_attributes.merge(password: password)
              }
            }
          end

          context 'valid password and user is not admin' do
            response '200', 'OK: User updated' do
              schema '$ref' => '#/definitions/user_patch_params_without_password'

              run_test! do
                expect(updated_user.reload.valid_password?(password)).to eql true
              end
            end
          end

          context 'valid password but user is admin' do
            let!(:updated_user) { create :user, admin: true, password: Faker::Internet.password }
            let(:error_detail) { 'Admin password change via API is not allowed.' }

            response '400', 'Bad Request' do
              schema '$ref' => '#/definitions/error_400'

              run_test! do
                expect(parsed_json['errors'][0]['detail']).to eql error_detail
              end
            end
          end
        end

        context 'user params include not permitted admin flag' do
          response '400', 'Error: Bad Request' do
            let(:example_attributes_with_admin) { example_attributes.merge(admin: true) }

            let(:user) do
              {
                data: {
                  type: 'users',
                  id: updated_user.id,
                  attributes: example_attributes_with_admin
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
end
