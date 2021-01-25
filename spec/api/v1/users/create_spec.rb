require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_user) { User.unscoped.last }

  let(:example_attributes) do
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

      let(:user) do
        {
          data: {
            type: 'users',
            attributes: example_attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'User created' do
        schema '$ref' => '#/definitions/user_post_params_without_password'

        run_test! do
          parsed_json_data_matches_db_record(created_user)
        end
      end

      context 'user attributes contain password' do
        parameter name: :user, in: :body, schema: { '$ref' => '#/definitions/user_post_params' }

        let(:user) do
          {
            data: {
              type: 'users',
              attributes: example_attributes.merge(password: password)
            }
          }
        end

        context 'valid password' do
          let(:password) { Faker::Internet.password }

          response '201', 'User created' do
            schema '$ref' => '#/definitions/user_post_params_without_password'
            run_test! do
              expect(created_user.valid_password?(password)).to eql true
            end
          end
        end

        context 'password is too short' do
          let(:password) { 'f00' }

          response '422', 'Unprocessable Entity' do
            schema '$ref' => '#/definitions/error_422_password_too_short'
            run_test!
          end
        end
      end

      # email already exists
      response '422', 'Unprocessable Entity' do
        let!(:existing_user) { create :user }
        let(:email) { existing_user.email }

        let(:example_attributes_with_existing_user_email) { example_attributes.merge(email: email) }

        let(:user) do
          {
            data: {
              type: 'users',
              attributes: example_attributes_with_existing_user_email
            }
          }
        end

        schema '$ref' => '#/definitions/error_422'
        run_test!
      end

      # user params include not permitted admin flag
      response '400', 'Error: Bad Request' do
        let(:example_attributes_with_admin) { example_attributes.merge(admin: true) }

        let(:user) do
          {
            data: {
              type: 'users',
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
