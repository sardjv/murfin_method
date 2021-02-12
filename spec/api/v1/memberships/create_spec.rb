require 'swagger_helper'

describe Api::V1::MembershipResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_membership) { Membership.find_by(user_id: user.id, user_group_id: user_group.id) }
  let!(:user) { create :user }
  let!(:user_group) { create :user_group }
  let!(:role) { 'member' }

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

      context 'role not valid' do
        let!(:role) { 'foobarist' }
        let(:error_detail) { "#{role} is not a valid value for role." }
        let(:error_title) { 'Invalid field value' }

        response '400', 'Bad request' do
          schema '$ref' => '#/definitions/error_400'
          run_test! do
            expect(parsed_json['errors'][0]['title']).to eql error_title
            expect(parsed_json['errors'][0]['detail']).to eql error_detail
          end
        end
      end

      context 'user id missing' do
        let(:attributes) do
          {
            user_group_id: user_group.id,
            role: role
          }
        end

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end
    end
  end
end
