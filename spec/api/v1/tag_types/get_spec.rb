require 'swagger_helper'

describe Api::V1::TagTypeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:tag_type) { create :tag_type }

  path '/api/v1/tag_types/{id}' do
    get 'get tag type' do
      tags 'TagTypes'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:id) { tag_type.id }

      response '200', 'Showing tag type' do
        schema '$ref' => '#/definitions/tag_type_response'

        run_test! do
          parsed_json_data_matches_db_record(tag_type)
        end
      end

      it_behaves_like 'has response unauthorized'
      it_behaves_like 'has response record not found'
      it_behaves_like 'has response unsupported accept header'
    end
  end
end
