require 'swagger_helper'

describe Api::V1::TimeRangeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:user1) { create :user }
  let(:user2) { create :user }

  let(:time_range_type_name1) { Faker::Lorem.unique.word }
  let(:time_range_type_name2) { Faker::Lorem.unique.word }

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
      parameter name: 'filter[appointment_id]', in: :query, type: :string, required: false
      parameter name: 'filter[user_id]', in: :query, type: :integer, required: false
      parameter name: 'filter[time_range_type_id]', in: :query, type: :integer, required: false
      parameter name: 'include', in: :query, type: :string, required: false, example: 'tags'

      let(:include) { '' }

      let(:'page[size]') { 10 }
      let(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Time Ranges index' do
        schema '$ref' => '#/definitions/time_ranges_response'

        run_test! do
          expect(parsed_json_data.count).to eq(2)

          database_record = TimeRange.find(parsed_json_data.first['id'])

          data = parsed_json_data.first
          data['attributes']['value'] = data['attributes'].delete('minutes_worked').to_d.to_s

          parsed_json_data_matches_db_record(database_record, data)
        end

        context 'include tags' do
          let(:include) { 'tags' }

          let!(:parent_tag_type) { create :tag_type }
          let!(:tag_type) { create :tag_type, parent: parent_tag_type }
          let!(:parent_tag) { create :tag, tag_type: parent_tag_type }

          let!(:tag1) { create :tag, parent: parent_tag, tag_type: tag_type }
          let!(:tag2) { create :tag, parent: parent_tag, tag_type: tag_type }
          let!(:tag3) { create :tag, parent: parent_tag, tag_type: tag_type }

          let!(:tag_association1) { create :tag_association, :skip_validate, tag: tag2, taggable: time_range1, tag_type: parent_tag_type }
          let!(:tag_association2) { create :tag_association, :skip_validate, tag: tag3, taggable: time_range1, tag_type: parent_tag_type }

          run_test! do
            expect(parsed_json_data.first['relationships']['tags']['data'].collect { |e| e['id'].to_i }).to match_array [tag2.id, tag3.id]
            expect(parsed_json['included'].collect { |e| e['attributes']['name'] }).to match_array [tag2.name, tag3.name]

            expect(parsed_json_data.second['relationships']['tags']['data']).to be_empty
          end
        end

        context 'with 1 result per page' do
          let(:'page[size]') { 1 }
          let(:'page[number]') { 2 }

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

          context 'appointment_id' do
            let(:'filter[appointment_id]') { time_range2.appointment_id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [time_range2.id]
            end
          end
        end
      end

      it_behaves_like 'has response unauthorized'
    end
  end
end
