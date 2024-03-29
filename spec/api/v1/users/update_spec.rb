require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_user) { create :user }

  let(:valid_attributes) do
    Swagger::V1::Users.definitions.dig(:user_updatable_attributes, :properties).transform_values do |v|
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
      let(:attributes) { valid_attributes }

      let(:user) do
        {
          data: {
            type: 'users',
            id: updated_user.id,
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'OK: User updated' do
        schema '$ref' => '#/definitions/user_response'

        run_test! do
          parsed_json_data_matches_db_record(updated_user)
        end
      end

      it_behaves_like 'has response unauthorized'

      context 'user attributes contain password' do
        let(:password) { Faker::Internet.password }

        let(:user) do
          {
            data: {
              type: 'users',
              id: updated_user.id,
              attributes: attributes.merge(password: password)
            }
          }
        end

        context 'valid password and user is not admin' do
          response '200', 'OK: User updated' do
            schema '$ref' => '#/definitions/user_response'

            run_test! do
              expect(updated_user.reload.valid_password?(password)).to eql true
            end
          end
        end

        context 'valid password but user is admin' do
          let!(:updated_user) { create :user, admin: true, password: Faker::Internet.password }

          it_behaves_like 'has response bad request' do
            let(:error_detail) { 'Admin password change via API is not allowed.' }
          end
        end
      end

      context 'user attributes contain ldap bind pair' do
        description 'Any LDAP related params should be lowercase and use <i>ldap_</i> prefix, e.g. <i>ldap_samaccountname<i>'

        let(:ldap_auth_bind_key) { 'samaccountname' }
        let(:ldap_auth_bind_key_field) { "ldap_#{ldap_auth_bind_key}".to_sym }
        let(:ldap_auth_bind_value) { Faker::Internet.username }
        let(:attributes) { valid_attributes.merge({ ldap_auth_bind_key_field => ldap_auth_bind_value }) }

        around do |example|
          ClimateControl.modify AUTH_METHOD: 'ldap', LDAP_AUTH_BIND_KEY: ldap_auth_bind_key do
            # we need to reload modules which use ENV variables we just had changed
            Object.send(:remove_const, :UsesLdap)
            Object.send(:remove_const, :ResourceUsesLdap)
            load 'app/models/concerns/uses_ldap.rb'
            load 'app/resources/concerns/resource_uses_ldap.rb'
            User.include(UsesLdap)
            Api::V1::UserResource.include(ResourceUsesLdap)

            example.run
          end
        end

        response '200', 'OK: User updated' do
          schema '$ref' => '#/definitions/user_response'

          run_test! do
            expect(updated_user.reload.send(ldap_auth_bind_key_field)).to eql ldap_auth_bind_value
          end
        end
      end

      context 'epr_uuid is null' do
        let(:attributes) { valid_attributes.merge(epr_uuid: '') }

        response '200', 'OK: User updated' do
          schema '$ref' => '#/definitions/user_response'

          run_test! do
            expect(updated_user.reload.epr_uuid).to eql nil
          end
        end
      end

      context 'user group relationships passed' do
        let!(:user_group1) { create :user_group }
        let!(:user_group2) { create :user_group }
        let!(:user_group3) { create :user_group }
        let!(:user_group4) { create :user_group }

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
              id: updated_user.id,
              attributes: attributes,
              relationships: relationships
            }
          }
        end

        response '200', 'OK: User updated' do
          schema '$ref' => '#/definitions/user_response_with_relationships'

          run_test! do
            expect(updated_user.user_groups.reload.pluck(:id)).to match_array [user_group1.id, user_group3.id]
          end
        end

        context 'user already has user group assigned' do
          before do
            updated_user.user_groups << user_group2
          end

          it_behaves_like 'has response forbidden' do
            let(:error_title) { 'Complete replacement forbidden' }
            let(:error_detail) { 'User already has user group(s) assigned. Use memberships POST endpoint.' }
          end
        end

        context 'user group ids are invalid' do
          let(:invalid_group_id1) { 543 }
          let(:invalid_group_id2) { 210 }

          let(:relationships) do
            {
              user_groups: {
                data: [
                  { type: 'user_groups', id: invalid_group_id1 },
                  { type: 'user_groups', id: invalid_group_id2 }
                ]
              }
            }
          end

          let(:error_title) { 'Record not found' }
          let(:error_detail) { "User groups with ids #{invalid_group_id1}, #{invalid_group_id2} not found." }
          let(:error_status) { '404' }
          let(:error_code) { '404' }

          response '404', 'Record not found' do
            schema '$ref' => '#/definitions/error_404'

            run_test! do
              expect(parsed_json_error[:title]).to eql error_title
              expect(parsed_json_error[:detail]).to eql error_detail
              expect(parsed_json_error[:status]).to eql error_status
              expect(parsed_json_error[:code]).to eql error_code
            end
          end
        end
      end

      context 'user params include not permitted admin flag' do
        response '400', 'Error: Bad Request' do
          let(:attributes_with_admin) { valid_attributes.merge(admin: true) }

          let(:user) do
            {
              data: {
                type: 'users',
                id: updated_user.id,
                attributes: attributes_with_admin
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
