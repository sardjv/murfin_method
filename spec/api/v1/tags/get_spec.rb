require 'swagger_helper'

describe Api::V1::TagResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:tag) { create :tag }

  path '/api/v1/tags/{id}' do
    get 'get tag' do
      tags 'Tags'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Showing tag type' do
        let!(:id) { tag.id }

        schema '$ref' => '#/definitions/tag_response'

        run_test! do
          parsed_json_data_matches_db_record(tag)
        end
      end

      it_behaves_like 'has response record not found'

      it_behaves_like 'has response unsupported accept header' do
        let(:id) { tag.id }
      end
    end
  end
end
