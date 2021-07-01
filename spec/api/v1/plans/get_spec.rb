require 'swagger_helper'

describe Api::V1::PlanResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:plan) { create :plan }

  path '/api/v1/plans/{id}' do
    get 'get plan' do
      tags 'Plans'
      security [{ JWT: {} }]
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: :include, in: :query, type: :string, required: false, example: 'activities'
      produces 'application/vnd.api+json'

      let(:Authorization) { 'Bearer dummy_json_web_token' }
      let(:include) { '' }

      response '200', 'Showing plan' do
        let(:id) { plan.id }
        schema '$ref' => '#/definitions/plan_response_with_relationships'

        run_test! do
          data = parsed_json_data

          parsed_json_data_matches_db_record(plan, data)
        end

        context 'include activities' do
          let(:include) { 'activities' }

          let!(:activity1a) { create :activity, plan: plan, seconds_per_week: 4 * 3600 } # 4h
          let!(:activity1b) { create :activity, plan: plan, seconds_per_week: 5.5 * 3600 } # 5.5h
          let!(:activity2) { create :activity, plan: create(:plan), seconds_per_week: 10 * 3600 } # other plan' activity

          run_test! do
            expect(parsed_json_data['relationships']['activities']['data'].collect { |e| e['id'].to_i }).to match_array [activity1a.id, activity1b.id]
            expect(parsed_json['included'].collect { |e| e['attributes']['minutes_per_week'] }).to match_array [4 * 60, 5.5 * 60]
          end
        end
      end

      it_behaves_like 'has response record not found'
      it_behaves_like 'has response unsupported accept header' do
        let(:id) { plan.id }
      end
    end
  end
end
