require 'swagger_helper'

describe Api::V1::TagAssociationResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_tag_association) { time_range.tag_associations.where(taggable: time_range).last }

  let!(:tag_type) { create :tag_type }
  let!(:tag) { create :tag, tag_type: tag_type }

  let!(:appointment_id) { Faker::Lorem.characters(number: 8) }
  let!(:time_range) { create :time_range, appointment_id: appointment_id }

  let(:valid_attributes) do
    {
      tag_id: tag.id,
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

          expect(created_tag_association.tag_type_id).to eql tag.tag_type_id
        end
      end

      describe 'find tabbable by time_range_appointment_id instead taggable_id and taggable_type' do
        context 'correct time_range_appointment_id passed' do
          let(:attributes) do
            {
              tag_id: tag.id,
              tag_type_id: tag_type.id,
              time_range_appointment_id: appointment_id
            }
          end

          response '201', 'Tag Association created' do
            schema '$ref' => '#/definitions/tag_association_response'

            run_test! do
              parsed_json_data_matches_db_record(created_tag_association)

              expect(created_tag_association.taggable).to eql time_range
            end
          end
        end

        context 'wrong time_range_appointment_id passed' do
          let(:attributes) do
            {
              tag_id: tag.id,
              tag_type_id: tag_type.id,
              time_range_appointment_id: 'l0r3m'
            }
          end

          it_behaves_like 'has response record not found' do
            let(:error_detail) { 'Time range with appointment id l0r3m not found.' }
          end
        end
      end

      # TODO: probably not needed, we don't have tag associations without tag id
      xcontext 'optional tag id not passed but passed tag type id' do
        let(:attributes) { valid_attributes.except(:tag_id).merge({ tag_type_id: tag_type.id }) }

        response '201', 'Tag Association created' do
          schema '$ref' => '#/definitions/tag_association_response'

          run_test! do
            parsed_json_data_matches_db_record(created_tag_association)
          end
        end
      end

      context 'tag id and tag type id not passed' do
        let(:attributes) { valid_attributes.except(:tag_id) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'tag_type - must exist' }
        end
      end

      context 'required taggable type is missing' do
        let(:attributes) { valid_attributes.except(:taggable_type) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'taggable - must exist' }
        end
      end

      context 'tag does not match tag type' do
        let!(:other_tag_type) { create :tag_type }
        let(:attributes) { valid_attributes.merge({ tag_type_id: other_tag_type.id }) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must belong to the selected tag_type' }
          let(:error_detail) { 'tag_id - must belong to the selected tag_type' }
        end
      end
    end
  end
end
