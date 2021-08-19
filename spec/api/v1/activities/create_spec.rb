require 'swagger_helper'

describe Api::V1::ActivityResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_activity) { Activity.unscoped.last }
  let!(:plan) { create :plan }

  let(:schedule_yaml) do
    "---\n:start_time: 2021-03-29 08:00:00.000000000 +01:00\n:end_time: 2021-03-29 12:00:00.000000000 +01:00\n:rrules:\n- :validations:\n    :day:\n    - 1\n  :rule_type: IceCube::WeeklyRule\n  :interval: 1\n  :week_start: 1\n:rtimes: []\n:extimes: []\n" # rubocop:disable Layout/LineLength
  end

  let(:schedule) { IceCube::Schedule.from_yaml(schedule_yaml) }
  let(:minutes_per_week) { 4 * 60 }
  let(:seconds_per_week) { minutes_per_week * 60 }

  let(:valid_attributes) do
    {
      plan_id: plan.id,
      schedule_yaml: schedule_yaml
    }
  end

  path '/api/v1/activities' do
    post 'create activity' do
      tags 'Activities'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :activity, in: :body, schema: { '$ref' => '#/definitions/activity_post_params' }
      description 'Attribute <b>schedule_yaml</b> is <a href="https://github.com/seejohnrun/ice_cube">IceCube</a> schedule object serialized with _to_yaml_ method.' # rubocop:disable Layout/LineLength

      let(:attributes) { valid_attributes }
      let(:relationships) { nil }

      let(:activity) do
        {
          data: {
            type: 'activities',
            attributes: attributes,
            relationships: relationships
          }.compact
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Activity created' do
        schema '$ref' => '#/definitions/activity_response'

        run_test! do
          expect(created_activity.plan_id).to eql plan.id
          expect(created_activity.schedule).to eql schedule
          expect(created_activity.start_time.strftime('%H:%M')).to eql '08:00'
          expect(created_activity.end_time.strftime('%H:%M')).to eql '12:00'
          expect(created_activity.seconds_per_week.to_i).to eql seconds_per_week

          expect(parsed_json_data['attributes']['minutes_per_week']).to eql minutes_per_week
        end
      end

      context 'plan not exists' do
        let(:attributes) { valid_attributes.merge({ plan_id: Faker::Number.number(digits: 10) }) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'plan - must exist' }
        end
      end

      context 'tag relationships passed' do
        let!(:tag1) { create :tag }
        let!(:tag2) { create :tag }
        let!(:tag3) { create :tag }

        let(:tag1_id) { tag1.id }
        let(:tag3_id) { tag3.id }

        let(:relationships) do
          {
            tags: {
              data: [
                { type: 'tags', id: tag1_id },
                { type: 'tags', id: tag3_id }
              ]
            }
          }
        end

        response '201', 'Activity created' do
          schema '$ref' => '#/definitions/activity_response_with_relationships'

          run_test! do
            expect(created_activity.tags.collect(&:id)).to match_array [tag1.id, tag3.id]
          end
        end

        context 'one of passed tags does not exist' do
          let(:tag3_id) { Faker::Number.number(digits: 10) }

          let(:error_title) { 'Record not found' }
          let(:error_detail) { "Tag with id #{tag3_id} not found." }

          response '404', 'Record not found' do
            schema '$ref' => '#/definitions/error_404'

            run_test! do
              expect(parsed_json['errors'][0]['title']).to eql error_title
              expect(parsed_json['errors'][0]['detail']).to eql error_detail
            end
          end
        end
      end

      it_behaves_like 'has response unauthorized'
    end
  end
end
