require 'swagger_helper'

describe Api::V1::TagResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_tag) { Tag.find_by(name: tag_name) }

  let!(:parent_tag_type) { create :tag_type }
  let!(:parent_tag) { create :tag, tag_type: parent_tag_type }

  let!(:tag_type) { create :tag_type, parent: parent_tag_type }

  let(:tag_name) { Faker::Lorem.word }

  let(:valid_attributes) do
    {
      name: tag_name,
      tag_type_id: tag_type.id,
      parent_id: parent_tag.id,
      default_for_filter: true
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/tags' do
    post 'create tag' do
      tags 'Tags'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :tag, in: :body, schema: { '$ref' => '#/definitions/tag_post_params' }

      let(:tag) do
        {
          data: {
            type: 'tags',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Tag created' do
        schema '$ref' => '#/definitions/tag_post_params'

        run_test! do
          parsed_json_data_matches_db_record(created_tag)
        end
      end

      context 'tag has no parent' do
        let!(:tag_type) { create :tag_type, parent_id: nil }
        let(:attributes) { valid_attributes.except(:parent_id) }

        response '201', 'Tag created' do
          schema '$ref' => '#/definitions/tag_post_params'

          run_test! do
            parsed_json_data_matches_db_record(created_tag)
          end
        end
      end

      context 'tag name not unique' do
        let!(:existing_tag) { create :tag, parent: parent_tag, tag_type: tag_type, name: tag_name }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'parent tag does not exist' do
        let(:attributes) { valid_attributes.merge({ parent_id: 111_222 }) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'tag type does not match tag parent type' do
        let(:other_tag_type) { create :tag_type }
        let!(:parent_tag) { create :tag, tag_type: other_tag_type }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'tag type is missing' do
        let(:attributes) { valid_attributes.except(:tag_type_id) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end
    end
  end
end
