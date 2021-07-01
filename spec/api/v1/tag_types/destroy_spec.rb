require 'swagger_helper'

describe Api::V1::TagTypeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:tag_type) { create :tag_type }

  path '/api/v1/tag_types/{id}' do
    delete 'destroy tag type' do
      tags 'TagTypes'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '204', 'OK: No Content' do
        let(:id) { tag_type.id }

        run_test! do
          refute(TagType.exists?(tag_type.id))
        end
      end

      it_behaves_like 'has response record not found'

      context 'tag type has tag with association' do
        let(:id) { tag_type.id }

        let!(:tag) { create :tag, tag_type: tag_type }
        let!(:tag_association) { create :tag_association, tag: tag }
        let(:error_detail) { 'Cannot delete record because dependent tag associations exist.' }

        response '423', 'Error: Locked Resource' do
          schema '$ref' => '#/definitions/error_423'

          run_test! do
            expect(parsed_json['errors'][0]['detail']).to eql error_detail
          end
        end
      end
    end
  end
end
