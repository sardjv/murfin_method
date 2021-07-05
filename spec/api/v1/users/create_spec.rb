require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_user) { User.unscoped.last }

  let(:valid_attributes) do
    Swagger::V1::Users.definitions.dig(:user_attributes_without_admin, :properties).transform_values do |v|
      v[:example]
    end
  end

  path '/api/v1/users' do
    post 'create user' do
      tags 'Users'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :user, in: :body, schema: { '$ref' => '#/definitions/user_post_params' }

      let(:attributes) { valid_attributes }

      let(:user) do
        {
          data: {
            type: 'users',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'User created' do
        schema '$ref' => '#/definitions/user_response'

        run_test! do
          parsed_json_data_matches_db_record(created_user)
        end
      end

      context 'user attributes contain password' do
        parameter name: :user, in: :body, schema: { '$ref' => '#/definitions/user_post_params' }

        let(:attributes) { valid_attributes.merge(password: password) }

        context 'valid password' do
          let(:password) { Faker::Internet.password }

          response '201', 'User created' do
            schema '$ref' => '#/definitions/user_response'

            run_test! do
              expect(created_user.valid_password?(password)).to eql true
            end
          end
        end

        context 'password is too short' do
          let(:password) { 'f00' }

          it_behaves_like 'has response unprocessable entity' do
            let(:error_title) { 'is too short (minimum is 6 characters)' }
            let(:error_detail) { 'password - is too short (minimum is 6 characters)' }
            let(:error_code) { JSONAPI::VALIDATION_ERROR }
          end
        end
      end

      context 'user group relationships passed' do
        let!(:user_group1) { create :user_group }
        let!(:user_group2) { create :user_group }
        let!(:user_group3) { create :user_group }

        let(:relationships) do
          {
            user_groups: {
              data: [
                { type: 'user_groups', id: user_group1.id },
                { type: 'user_groups', id: user_group3.id }
              ]
            }
          }
        end

        let(:user) do
          {
            data: {
              type: 'users',
              attributes: attributes,
              relationships: relationships
            }
          }
        end

        response '201', 'User created' do
          schema '$ref' => '#/definitions/user_response_with_relationships'

          run_test! do
            expect(created_user.user_groups.pluck(:id)).to match_array [user_group1.id, user_group3.id]
          end
        end

        it_behaves_like 'has response unauthorized'

        context 'one user group id is invalid' do
          let(:invalid_group_id) { 543_210 }

          let(:relationships) do
            {
              user_groups: {
                data: [
                  { type: 'user_groups', id: user_group1.id },
                  { type: 'user_groups', id: invalid_group_id }
                ]
              }
            }
          end

          it_behaves_like 'has response record not found' do
            let(:error_detail) { "User group with id #{invalid_group_id} not found." }
          end
        end
      end

      context 'email already taken' do
        let!(:existing_user) { create :user }
        let(:email) { existing_user.email }
        let(:attributes) { valid_attributes.merge(email: email) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'has already been taken' }
          let(:error_detail) { 'email - has already been taken' }
        end
      end

      context 'user params include not permitted admin flag' do
        let(:attributes) { valid_attributes.merge(admin: true) }

        it_behaves_like 'has response bad request' do
          let(:error_detail) { 'admin is not allowed.' }
        end
      end
    end
  end
end
