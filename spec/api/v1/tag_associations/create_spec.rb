require 'swagger_helper'

describe Api::V1::TagAssociationResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_tag_association) { time_range.tag_associations.where(tag_type_id: tag_type.id).last }

  let!(:tag_type) { create :tag_type }
  let!(:tag) { create :tag, tag_type: tag_type }
  let!(:time_range) { create :time_range }

  let(:valid_attributes) do
    {
      tag_id: tag.id,
      tag_type_id: tag_type.id,
      taggable_id: time_range.id,
      taggable_type: time_range.class.name
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/tag_associations' do
    post 'create tag association' do
      tags 'TagAssociations'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :tag_association, in: :body, schema: { '$ref' => '#/definitions/tag_association_post_params' }

      let(:tag_association) do
        {
          data: {
            type: 'tag_associations',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Tag Association created' do
        schema '$ref' => '#/definitions/tag_association_response'

        run_test! do
          parsed_json_data_matches_db_record(created_tag_association)
        end
      end

      context 'optional tag id not passed' do
        let(:attributes) { valid_attributes.except(:tag_id) }

        response '201', 'Tag Association created' do
          schema '$ref' => '#/definitions/tag_association_response'

          run_test! do
            parsed_json_data_matches_db_record(created_tag_association)
          end
        end
      end

      context 'required tag type not passed so is assigned from tag' do
        let(:attributes) { valid_attributes.except(:tag_type_id) }

        response '201', 'Tag Association created' do
          schema '$ref' => '#/definitions/tag_association_response'

          run_test! do
            created_tag_association.tag_type = tag.tag_type
          end
        end
      end

      context 'required taggable type is missing' do
        let(:attributes) { valid_attributes.except(:taggable_type) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'tag does not match tag type' do
        let!(:other_tag_type) { create :tag_type }
        let(:error_detail) { 'tag_id - must belong to the selected tag_type' }
        let(:error_title) { 'must belong to the selected tag_type' }

        let(:attributes) { valid_attributes.merge({ tag_type_id: other_tag_type.id }) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test! do
            expect(parsed_json['errors'][0]['title']).to eql error_title
            expect(parsed_json['errors'][0]['detail']).to eql error_detail
          end
        end
      end
    end
  end
end
