require 'swagger_helper'

describe Api::V1::PlanResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:user1) { create :user }
  let(:user2) { create :user }

  let!(:plan1) { create :plan, user: user1 }
  let!(:plan2) { create :plan, user: user2 }

  path '/api/v1/plans' do
    get 'get plans' do
      tags 'Plans'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false
      parameter name: 'filter[user_id]', in: :query, type: :integer, required: false
      parameter name: 'include', in: :query, type: :string, required: false

      let(:include) { '' }

      let(:'page[size]') { 10 }
      let(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'Plans index' do
        schema '$ref' => '#/definitions/plans_response'

        run_test! do
          expect(parsed_json_data.count).to eq(2)

          [plan1, plan2].each do |db_record|
            data = parsed_json_data.detect { |e| e['id'] == db_record.id.to_s }
            parsed_json_data_matches_db_record(db_record, data)
          end
        end

        context 'include activities' do
          let(:include) { 'activities' }

          let!(:activity1a) { create :activity, plan: plan1 }
          let!(:activity1b) { create :activity, plan: plan1 }
          let!(:activity2a) { create :activity, plan: plan2 }
          let!(:plan3) { create :plan, user: create(:user) }

          run_test! do
            expect(parsed_json_data[0]['relationships']['activities']['data'].collect do |e|
                     e['id'].to_i
                   end).to match_array [activity1a.id, activity1b.id]
            expect(parsed_json_data[1]['relationships']['activities']['data'].collect { |e| e['id'].to_i }).to match_array [activity2a.id]
            expect(parsed_json_data[2]['relationships']['activities']['data']).to be_empty

            expect(parsed_json['included'].collect { |e| e['attributes']['plan_id'] }.uniq).to match_array [plan1.id, plan2.id]
          end
        end

        describe 'filters' do
          context 'user_id' do
            let(:'filter[user_id]') { user2.id }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [plan2.id]
            end
          end
        end

        context 'with 1 result per page' do
          let(:'page[size]') { 1 }
          let(:'page[number]') { 2 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(plan2.id.to_s)
            expect(parsed_json_data.first['attributes']['user_id']).to eq(user2.id)
          end
        end
      end
    end
  end
end
