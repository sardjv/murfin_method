require 'swagger_helper'

describe Api::V1::MembershipResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_membership) { Membership.unscoped.last }

  let(:epr_uuid) { Faker::Internet.uuid }
  let!(:user) { create :user, epr_uuid: epr_uuid }
  let!(:user_group) { create :user_group }
  let(:role) { 'member' }

  let(:valid_attributes) do
    {
      user_id: user.id,
      user_group_id: user_group.id,
      role: role
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/memberships' do
    post 'create membership' do
      tags 'Memberships'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :membership, in: :body, schema: { '$ref' => '#/definitions/membership_post_params' }
      description 'Can use <strong>user_epr_uuid</strong> instead of <strong>user_id</strong>. Do not use both.'

      let(:membership) do
        {
          data: {
            type: 'memberships',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Membership created' do
        schema '$ref' => '#/definitions/membership_response'

        run_test! do
          parsed_json_data_matches_db_record(created_membership)
        end
      end

      it_behaves_like 'has response unauthorized'

      context 'role not valid' do
        let!(:role) { 'foobarist' }

        it_behaves_like 'has response bad request' do
          let(:error_title) { 'Invalid field value' }
          let(:error_detail) { "#{role} is not a valid value for role." }
        end
      end

      context 'user id missing' do
        let(:attributes) do
          {
            user_group_id: user_group.id,
            role: role
          }
        end

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'user - must exist' }
        end
      end

      context 'find user by user_epr_uuid instead user_id' do
        context 'correct user_epr_uuid passed' do
          let(:attributes) { valid_attributes.except(:user_id).merge({ user_epr_uuid: epr_uuid }) }

          response '201', 'Membership created' do
            schema '$ref' => '#/definitions/membership_response'
          end
        end

        context 'invalid user_epr_uuid passed' do
          let(:attributes) { valid_attributes.except(:user_id).merge({ user_epr_uuid: 'f00' }) }

          let(:error_detail) { 'User with EPR UUID f00 not found.' }

          it_behaves_like 'has response record not found'
        end

        context 'missing both user_id and user_epr_uuid' do
          let(:attributes) { valid_attributes.except(:user_id) }

          it_behaves_like 'has response unprocessable entity' do
            let(:error_title) { 'must exist' }
            let(:error_detail) { 'user - must exist' }
          end
        end

        context 'both user_id and user_epr_uuid passed' do
          let(:attributes) { valid_attributes.merge({ user_epr_uuid: epr_uuid }) }

          it_behaves_like 'has response bad request' do
            let(:error_detail) { 'To identify user you need to pass user_id OR user_epr_uuid, not both.' }
          end
        end
      end
    end
  end
end
