require 'swagger_helper'

describe Api::V1::TimeRangeResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_time_range) { TimeRange.unscoped.last }

  let(:epr_uuid) { Faker::Internet.uuid }
  let(:user) { create :user, epr_uuid: epr_uuid }
  let(:time_range_type) { create :time_range_type }
  let(:appointment_id) { Faker::Lorem.characters(number: 8) }

  let(:valid_attributes) do
    {
      user_id: user.id,
      start_time: 1.hour.since.iso8601,
      end_time: 20.hours.since.iso8601,
      minutes_worked: 50,
      time_range_type_id: time_range_type.id,
      appointment_id: appointment_id
    }
  end

  let(:attributes) { valid_attributes }

  path '/api/v1/time_ranges' do
    post 'create time range' do
      tags 'TimeRanges'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :time_range, in: :body, schema: { '$ref' => '#/definitions/time_range_post_params' }

      let(:time_range) do
        {
          data: {
            type: 'time_ranges',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Time Range created' do
        schema '$ref' => '#/definitions/time_range_response'

        run_test! do
          data = parsed_json_data
          data['attributes']['value'] = data['attributes'].delete('minutes_worked').to_d.to_s

          parsed_json_data_matches_db_record(created_time_range, data)
        end
      end

      context 'find user by user_epr_uuid instead user_id' do
        context 'correct user_epr_uuid passed' do
          let(:attributes) { valid_attributes.except(:user_id).merge({ user_epr_uuid: epr_uuid }) }

          response '201', 'Time Range created' do
            schema '$ref' => '#/definitions/time_range_response'

            run_test! do
              data = parsed_json_data
              data['attributes']['value'] = data['attributes'].delete('minutes_worked').to_d.to_s
              data['attributes']['user_id'] = user.id

              parsed_json_data_matches_db_record(created_time_range, data)
            end
          end
        end

        context 'wrong user_epr_uuid passed' do
          let(:attributes) { valid_attributes.except(:user_id).merge({ user_epr_uuid: 'f00' }) }
          let(:error_title) { 'Record not found' }
          let(:error_detail) { 'User with EPR UUID f00 not found.' }

          response '404', 'Record not found' do
            schema '$ref' => '#/definitions/error_404'

            run_test! do
              expect(parsed_json['errors'][0]['title']).to eql error_title
              expect(parsed_json['errors'][0]['detail']).to eql error_detail
            end
          end
        end

        context 'missing both user_id and user_epr_uuid' do
          let(:attributes) { valid_attributes.except(:user_id) }
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'user - must exist' }

          response '422', 'Invalid request' do
            schema '$ref' => '#/definitions/error_422'

            run_test! do
              expect(parsed_json['errors'][0]['title']).to eql error_title
              expect(parsed_json['errors'][0]['detail']).to eql error_detail
            end
          end
        end
      end

      context 'start time after end time' do
        let(:attributes) { valid_attributes.merge({ start_time: 20.hours.since.iso8601, end_time: 1.hour.since.iso8601 }) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'user not exists' do
        let(:attributes) { valid_attributes.merge({ user_id: 987_654 }) }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422_start_end_time'
          run_test!
        end
      end

      context 'appointment id already used' do
        let!(:other_time_range) { create :time_range, appointment_id: appointment_id }

        response '422', 'Invalid request' do
          schema '$ref' => '#/definitions/error_422'
          run_test!
        end
      end

      context 'tag relationships passed' do
        let!(:tag1) { create :tag }
        let!(:tag2) { create :tag }
        let!(:tag3) { create :tag }

        let(:relationships) do
          {
            tags: {
              data: [
                { type: 'tags', id: tag2.id },
                { type: 'tags', id: tag3.id }
              ]
            }
          }
        end

        let(:time_range) do
          {
            data: {
              type: 'time_ranges',
              attributes: attributes,
              relationships: relationships
            }
          }
        end

        response '201', 'Time Range created' do
          schema '$ref' => '#/definitions/time_range_response_with_relationships'

          run_test! do
            expect(created_time_range.tags.collect(&:id)).to match_array [tag2.id, tag3.id]
          end
        end
      end
    end
  end
end
