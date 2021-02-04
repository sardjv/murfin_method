require 'swagger_helper'

describe Api::V1::TagResource, type: :request, swagger_doc: 'v1/swagger.json' do
  path '/api/v1/tags/{id}' do
    patch 'update tag' do
      tags 'Tags'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :tag, in: :body, schema: { '$ref' => '#/definitions/tag_patch_params' }

      let!(:updated_tag) { create :tag }
      let(:id) { updated_tag.id }
      let(:tag_name) { Faker::Lorem.word }
      let(:attributes) { { name: tag_name } }

      let(:tag) do
        {
          data: {
            type: 'tags',
            id: updated_tag.id,
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'OK: Tag updated' do
        schema '$ref' => '#/definitions/tag_patch_params'

        run_test! do
          expect(updated_tag.reload.name).to eql tag_name
        end
      end
    end
  end
end
