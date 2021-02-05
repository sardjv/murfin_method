require 'swagger_helper'

describe Api::V1::TimeRangeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:time_range) { create :time_range }

  path '/api/v1/time_ranges/{id}' do
    get 'get time range' do
      tags 'TimeRanges'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :include, in: :query, type: :string, required: false
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:id) { time_range.id }
      let(:include) { '' }

      response '200', 'Showing time range' do
        schema '$ref' => '#/definitions/time_range_response'

        run_test! do
          data = parsed_json_data
          data['attributes']['value'] = data['attributes'].delete('minutes_worked').to_d.to_s

          parsed_json_data_matches_db_record(time_range, data)
        end
      end

      context 'include tags' do
        let(:include) { 'tags' }

        let!(:parent_tag_type) { create :tag_type }
        let!(:tag_type) { create :tag_type, parent: parent_tag_type }
        let!(:parent_tag) { create :tag, tag_type: parent_tag_type }

        let!(:tag1) { create :tag, parent: parent_tag, tag_type: tag_type }
        let!(:tag2) { create :tag, parent: parent_tag, tag_type: tag_type }
        let!(:tag3) { create :tag, parent: parent_tag, tag_type: tag_type }

        let!(:tag_association1) { create :tag_association, :skip_validate, tag: tag1, taggable: time_range, tag_type: parent_tag_type }
        let!(:tag_association2) { create :tag_association, :skip_validate, tag: tag3, taggable: time_range, tag_type: parent_tag_type }

        response '200', 'Showing time range' do
          schema '$ref' => '#/definitions/time_range_response_with_relationships'

          run_test! do
            expect(parsed_json_data['relationships']['tags']['data'].collect { |e| e['id'].to_i }).to match_array [tag1.id, tag3.id]
            expect(parsed_json['included'].collect { |e| e['attributes']['name'] }).to match_array [tag1.name, tag3.name]
          end
        end
      end

      response '404', 'Record not found' do
        let(:id) { 999_888 }
        run_test!
      end

      response '406', 'Unsupported accept header' do
        let(:Accept) { 'application/json' }
        run_test!
      end
    end
  end
end
