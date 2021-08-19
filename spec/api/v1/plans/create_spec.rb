require 'swagger_helper'

describe Api::V1::PlanResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:created_plan) { Plan.unscoped.last }
  let(:user) { create :user }

  let(:valid_attributes) do
    Swagger::V1::Plans.definitions.dig(:plan_attributes, :properties).transform_values do |v|
      v[:example]
    end.merge({ user_id: user.id })
  end

  path '/api/v1/plans' do
    post 'create plan' do
      tags 'Plans'
      security [{ JWT: {} }]
      consumes 'application/vnd.api+json'
      produces 'application/vnd.api+json'
      parameter name: :plan, in: :body, schema: { '$ref' => '#/definitions/plan_post_params' }

      let(:attributes) { valid_attributes }

      let(:plan) do
        {
          data: {
            type: 'plans',
            attributes: attributes
          }
        }
      end

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '201', 'Plan created' do
        schema '$ref' => '#/definitions/plan_response'

        run_test! do
          parsed_json_data_matches_db_record(created_plan)
        end
      end

      context 'user id attribute missing' do
        let(:attributes) { valid_attributes.except(:user_id) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'user - must exist' }
        end
      end

      context 'user does not exist' do
        let(:attributes) { valid_attributes.merge({ user_id: Faker::Number.number(digits: 10) }) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must exist' }
          let(:error_detail) { 'user - must exist' }
        end
      end

      context 'start date after end date' do
        let(:attributes) { valid_attributes.merge({ start_date: 1.day.ago.to_date, end_date: 2.days.ago.to_date }) }

        it_behaves_like 'has response unprocessable entity' do
          let(:error_title) { 'must occur after start date' }
          let(:error_detail) { 'end_date - must occur after start date' }
        end
      end
    end
  end
end
