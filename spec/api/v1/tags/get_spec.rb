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
      let!(:id) { tag.id }

      response '200', 'Showing tag type' do
        schema '$ref' => '#/definitions/tag_response'

        run_test! do
          parsed_json_data_matches_db_record(tag)
        end
      end

      response '404', 'Record not found' do
        schema '$ref' => '#/definitions/error_404'

        let(:id) { 999_888 }

        run_test!
      end

      response '406', 'Unsupported accept header' do
        schema '$ref' => '#/definitions/error_406'

        let(:Accept) { 'application/json' }
        run_test!
      end
    end
  end
end
