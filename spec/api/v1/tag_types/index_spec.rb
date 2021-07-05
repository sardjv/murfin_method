require 'swagger_helper'

describe Api::V1::TagTypeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:tag_type_name1) { Faker::Lorem.unique.word }
  let(:tag_type_name2) { Faker::Lorem.unique.word }
  let(:tag_type_name3) { Faker::Lorem.unique.word }
  let(:tag_type_name4) { Faker::Lorem.unique.word }

  let!(:tag_type1) { create :tag_type, name: tag_type_name1 }
  let!(:tag_type2) { create :tag_type, name: tag_type_name2, parent: tag_type1 }
  let!(:tag_type3) { create :tag_type, name: tag_type_name3 }
  let!(:tag_type4) { create :tag_type, name: tag_type_name4 }

  path '/api/v1/tag_types' do
    get 'get tag types' do
      tags 'TagTypes'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false

      let!(:'page[size]') { 10 }
      let!(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Tag Types index' do
        schema '$ref' => '#/definitions/tag_types_response'

        run_test! do
          expect(parsed_json_data.count).to eq(4)

          database_record = TagType.find(parsed_json_data.first['id'])
          parsed_json_data_matches_db_record(database_record, parsed_json_data.first)
        end

        context 'with 1 result per page' do
          let!(:'page[size]') { 1 }
          let!(:'page[number]') { 3 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(tag_type3.id.to_s)
          end
        end
      end

      it_behaves_like 'has response unauthorized'
    end
  end
end
