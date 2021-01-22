require 'swagger_helper'

describe Api::V1::TimeRangeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:time_range) { create :time_range }

  path '/api/v1/time_ranges/{id}' do
    get 'get time range' do
      tags 'TimeRanges'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let!(:id) { time_range.id }

      response '200', 'Showing time range' do
        schema '$ref' => '#/definitions/time_range_response'

        run_test! do
          parsed_json_data_matches_db_record(time_range)
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
