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

      let(:id) { user.id }

      response '200', 'Showing user' do
        schema '$ref' => '#/definitions/user_response_with_relationships'

        run_test! do
          parsed_json_data_matches_db_record(user)
        end
      end

      context 'user attributes contain ldap bind pair' do
        let(:ldap_auth_bind_key) { 'samaccountname' }
        let(:ldap_auth_bind_key_field) { "ldap_#{ldap_auth_bind_key}".to_sym }
        let(:ldap_auth_bind_value) { Faker::Internet.username }

        before do
          user.update_attribute :ldap, { ldap_auth_bind_key => ldap_auth_bind_value }
        end

        around do |example|
          ClimateControl.modify AUTH_METHOD: 'ldap', LDAP_AUTH_BIND_KEY: ldap_auth_bind_key do
            example.run
          end
        end

        response '200', 'Showing user' do
          schema '$ref' => '#/definitions/user_response_with_relationships'

          run_test! do
            parsed_json_data_matches_db_record(user)
          end
        end
      end

      it_behaves_like 'has response unauthorized'
      it_behaves_like 'has response record not found'
      it_behaves_like 'has response unsupported accept header'
    end
  end
end
