require 'swagger_helper'

describe Api::V1::TagResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:tag_type_name1) { Faker::Lorem.unique.word }
  let(:tag_type_name2) { Faker::Lorem.unique.word }
  let(:tag_type_name3) { Faker::Lorem.unique.word }
  let(:tag_type_name4) { Faker::Lorem.unique.word }

  let!(:tag_type1) { create :tag_type, name: tag_type_name1 }
  let!(:tag_type2) { create :tag_type, name: tag_type_name2, parent: tag_type1 }
  let!(:tag_type3) { create :tag_type, name: tag_type_name3 }
  let!(:tag_type4) { create :tag_type, name: tag_type_name4 }

  let(:tag_name1) { Faker::Lorem.unique.word }
  let(:tag_name2) { Faker::Lorem.unique.word }
  let(:tag_name3) { Faker::Lorem.unique.word }
  let(:tag_name4) { Faker::Lorem.unique.word }

  let!(:tag1) { create :tag, name: tag_name1, tag_type: tag_type1 }
  let!(:tag1a) { create :tag, name: tag_name2, tag_type: tag_type2, parent: tag1 }
  let!(:tag2) { create :tag, name: tag_name3, tag_type: tag_type3 }
  let!(:tag3) { create :tag, name: tag_name4, tag_type: tag_type4 }

  path '/api/v1/tags' do
    get 'get tags' do
      tags 'Tags'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false
      parameter name: 'filter[tag_type_id]', in: :query, type: :integer, required: false
      parameter name: 'filter[parent_id]', in: :query, type: :integer, required: false

      let!(:'page[size]') { 10 }
      let!(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Tags index' do
        schema '$ref' => '#/definitions/tags_response'

        run_test! do
          expect(parsed_json_data.count).to eq(4)

          database_record = Tag.find(parsed_json_data.first['id'])
          parsed_json_data_matches_db_record(database_record, parsed_json_data.first)
        end

        context 'with 1 result per page' do
          let!(:'page[size]') { 1 }
          let!(:'page[number]') { 3 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(tag2.id.to_s)
            expect(parsed_json_data.first['attributes']['tag_type_id']).to eq(tag_type3.id)
          end
        end

        describe 'filters' do
          context 'tag_type_id' do
            let(:'filter[tag_type_id]') { tag_type3.id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [tag2.id]
            end
          end

          context 'parent_id' do
            let(:'filter[parent_id]') { tag1.id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [tag1a.id]
            end
          end
        end
      end
    end
  end
end
