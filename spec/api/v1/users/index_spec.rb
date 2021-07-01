require 'swagger_helper'

describe Api::V1::UserResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  path '/api/v1/users' do
    get 'get users' do
      tags 'Users'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false
      parameter name: 'include', in: :query, type: :string, required: false, example: 'user_groups'

      let(:include) { '' }

      parameter name: 'filter[email]', in: :query, type: :string, required: false
      parameter name: 'filter[epr_uuid]', in: :query, type: :string, required: false

      let!(:'page[size]') { 2 }
      let!(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      let(:user1_data) { parsed_json_data.find { |d| d['id'] == user1.id.to_s } }
      let(:user2_data) { parsed_json_data.find { |d| d['id'] == user2.id.to_s } }

      response '200', 'Users index' do
        schema '$ref' => '#/definitions/users_response'

        run_test! do
          expect(parsed_json_data.count).to eq(2)

          parsed_json_data_matches_db_record(user1, user1_data)
          parsed_json_data_matches_db_record(user2, user2_data)
        end

        context 'with 1 result per page' do
          let!(:'page[size]') { 1 }
          let!(:'page[number]') { 2 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(user2.id.to_s)
            expect(parsed_json_data.first['attributes']['email']).to eq(user2.email)
          end
        end

        context 'include user groups' do
          let(:include) { 'user_groups' }

          let!(:user_group1) { create :user_group }
          let!(:user_group2) { create :user_group }
          let!(:user_group3) { create :user_group }

          before do
            user1.user_groups << [user_group2, user_group1]
          end

          run_test! do
            expect(user1_data['relationships']['user_groups']['data'].collect { |e| e['id'].to_i }).to match_array [user_group1.id, user_group2.id]
            expect(user2_data['relationships']['user_groups']['data']).to be_empty

            expect(parsed_json['included'].collect { |e| e['attributes']['name'] }).to match_array [user_group1.name, user_group2.name]
          end
        end

        describe 'filters' do
          context 'email' do
            let(:'filter[email]') { user2.email }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [user2.id]
            end
          end

          context 'epr_uuid' do
            let(:'filter[epr_uuid]') { user1.epr_uuid }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [user1.id]
            end
          end
        end
      end

      it_behaves_like 'has response unsupported accept header'
    end
  end
end
