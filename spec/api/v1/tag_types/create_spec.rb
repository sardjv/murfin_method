require 'swagger_helper'

describe Api::V1::TagTypeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_tag_type) { TagType.find_by(name: tag_type_name) }

  let!(:parent_tag_type) { create :tag_type }
  let(:active_for_activities_at) { 1.hour.since.iso8601 }
  let(:active_for_time_ranges_at) { 2.hours.since.iso8601 }

  let(:tag_type_name) { Faker::Lorem.word }

  let(:valid_attributes) do
    {
      name: tag_type_name,
      parent_id: parent_tag_type.id,
      active_for_activities_at: active_for_activities_at,
      active_for_time_ranges_at: active_for_time_ranges_at
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/tag_types' do
    post 'create tag type' do
      tags 'TagTypes'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :tag_type, in: :body, schema: { '$ref' => '#/definitions/tag_type_post_params' }

      let(:tag_type) do
        {
          data: {
            type: 'tag_types',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Tag Type created' do
        schema '$ref' => '#/definitions/tag_type_post_params'

        run_test! do
          parsed_json_data_matches_db_record(created_tag_type)
        end
      end

      context 'tag type has no parent' do
        let(:attributes) { valid_attributes.except(:parent_id) }

        response '201', 'Tag Type created' do
          schema '$ref' => '#/definitions/tag_type_post_params'

          run_test! do
            parsed_json_data_matches_db_record(created_tag_type)
          end
        end
      end

      context 'tag type name not unique' do
        let!(:existing_tag_type) { create :tag_type, name: tag_type_name }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'has already been taken' }
          let(:error_detail) { 'name - has already been taken' }
        end
      end
    end
  end
end
