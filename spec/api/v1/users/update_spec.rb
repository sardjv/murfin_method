require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_user) { create :user }

  let(:valid_attributes) do
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
          updated_user.reload
          attributes.each do |key, value|
            expect(value.to_s).to eq(updated_user.send(key).to_s)
          end
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

          it_behaves_like 'has response record not found' do
            let!(:error_detail) { "User groups with ids #{invalid_group_id1}, #{invalid_group_id2} not found." }
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
