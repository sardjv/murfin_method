require 'swagger_helper'

describe Api::V1::TagTypeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:updated_tag_type) { create :tag_type }

  let(:valid_attributes) do
    Swagger::V1::TagTypes.definitions.dig(:tag_type_attributes, :properties).transform_values do |v|
      v[:example]
    end
  end

  path '/api/v1/tag_types/{id}' do
    patch 'update tag' do
      tags 'TagTypes'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :tag_type, in: :body, schema: { '$ref' => '#/definitions/tag_type_patch_params' }

      let(:id) { updated_tag_type.id }
      let(:attributes) { valid_attributes }

      let(:tag_type) do
        {
          data: {
            type: 'tag_types',
            id: updated_tag_type.id,
            attributes: attributes
          }
        }
      end

      context 'authorized' do
        let(:Authorization) { 'Bearer dummy_json_web_token' }

        response '200', 'OK: Tag updated' do
          schema '$ref' => '#/definitions/tag_type_patch_params'

          run_test! do
            parsed_json_data_matches_db_record(updated_tag_type)
          end
        end

        context 'tag type name not unique' do
          let(:tag_type_name) { Faker::Lorem.word }
          let!(:existing_tag_type) { create :tag_type, name: tag_type_name }
          let(:attributes) { valid_attributes.merge({ name: tag_type_name }) }

          response '422', 'Invalid request' do
            schema '$ref' => '#/definitions/error_422'
            run_test!
          end
        end
      end
    end
  end
end
