require 'swagger_helper'

describe Api::V1::MembershipResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:membership) { create :membership }

  path '/api/v1/memberships/{id}' do
    delete 'destroy membership' do
      tags 'Memberships'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:id) { membership.id }

      response '204', 'OK: No Content' do
        run_test! do
          refute(Membership.exists?(membership.id))
        end
      end

      it_behaves_like 'has response unauthorized'
      it_behaves_like 'has response record not found'
    end
  end
end
