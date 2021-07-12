require 'swagger_helper'

describe Api::V1::TagAssociationResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:tag_association) { create :tag_association }

  path '/api/v1/tag_associations/{id}' do
    delete 'destroys tag association' do
      tags 'TagAssociations'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:id) { tag_association.id }
      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '204', 'OK: No Content' do
        run_test! do
          refute(TagAssociation.exists?(tag_association.id))
        end
      end

      it_behaves_like 'has response unauthorized'
      it_behaves_like 'has response record not found'
    end
  end
end
