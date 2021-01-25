require 'swagger_helper'

describe Api::V1::TimeRangeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:user1) { create :user }
  let(:user2) { create :user }

  let(:time_range_type_name1) { Faker::Lorem.word }
  let(:time_range_type_name2) { Faker::Lorem.word }

  let(:time_range_type1) { create :time_range_type, name: time_range_type_name1 }
  let(:time_range_type2) { create :time_range_type, name: time_range_type_name2 }

  let!(:time_range1) { create :time_range, user: user1, time_range_type: time_range_type1 }
  let!(:time_range2) { create :time_range, user: user2, time_range_type: time_range_type2 }

  path '/api/v1/time_ranges' do
    get 'get time ranges' do
      tags 'TimeRanges'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false
      parameter name: 'filter[user_id]', in: :query, type: :integer, required: false
      parameter name: 'filter[time_range_type_id]', in: :query, type: :integer, required: false

      let!(:'page[size]') { 10 }
      let!(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Time Ranges index' do
        schema '$ref' => '#/definitions/time_ranges_response'

        describe 'attributes match database values' do
          run_test! do
            expect(parsed_json_data.count).to eq(2)

            database_record = TimeRange.find(parsed_json_data.first['id'])
            parsed_json_data_matches_db_record(database_record, parsed_json_data.first)
          end
        end

        context 'with 1 result per page' do
          let!(:'page[size]') { 1 }
          let!(:'page[number]') { 2 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(time_range2.id.to_s)
            expect(parsed_json_data.first['attributes']['user_id']).to eq(user2.id)
          end
        end

        describe 'filters' do
          context 'user_id' do
            let(:'filter[user_id]') { user2.id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [time_range2.id]
            end
          end

          context 'time_range_type_id' do
            let(:'filter[time_range_type_id]') { time_range_type1.id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [time_range1.id]
            end
          end
        end
      end
    end
  end
end
