require 'swagger_helper'

describe Api::V1::TagResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:tag) { create :tag }

  path '/api/v1/tags/{id}' do
    delete 'destroys tag' do
      tags 'Tags'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '204', 'OK: No Content' do
        let(:id) { tag.id }

        run_test! do
          refute(Tag.exists?(tag.id))
        end
      end

      context 'tag has associations' do
        let(:id) { tag.id }
        let!(:tag_association) { create :tag_association, :skip_validate, tag: tag }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'Cannot delete record because dependent tag associations exist' }
          let(:error_detail) { 'Cannot delete record because dependent tag associations exist' }
        end
      end

      it_behaves_like 'has response record not found'
    end
  end
end
