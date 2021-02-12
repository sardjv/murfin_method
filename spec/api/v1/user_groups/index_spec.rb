require 'swagger_helper'

describe Api::V1::UserGroupResource, type: :request, swagger_doc: 'v1/swagger.json' do
  let(:user_group_name1) { Faker::Lorem.unique.word }
  let(:user_group_name2) { Faker::Lorem.unique.word }
  let(:user_group_name3) { Faker::Lorem.unique.word }

  let(:group_type1) { create :group_type }
  let(:group_type2) { create :group_type }

  let!(:user_group1) { create :user_group, name: user_group_name1, group_type: group_type1 }
  let!(:user_group2) { create :user_group, name: user_group_name2, group_type: group_type2 }
  let!(:user_group3) { create :user_group, name: user_group_name3, group_type: group_type2 }

  path '/api/v1/user_groups' do
    get 'get user groups' do
      tags 'UserGroups'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false
      parameter name: 'filter[name]', in: :query, type: :string, required: false
      parameter name: 'filter[group_type_id]', in: :query, type: :integer, required: false

      let!(:'page[size]') { 10 }
      let!(:'page[number]') { 1 }

      let(:Authorization) { 'Bearer dummy_json_web_token' }

      response '200', 'User Groups index' do
        schema '$ref' => '#/definitions/user_groups_response'

        run_test! do
          expect(parsed_json_data.count).to eq(3)

          database_record = UserGroup.find(parsed_json_data.first['id'])
          parsed_json_data_matches_db_record(database_record, parsed_json_data.first)
        end

        context 'with 1 result per page' do
          let!(:'page[size]') { 1 }
          let!(:'page[number]') { 3 }

          run_test! do
            expect(parsed_json_data.first['id']).to eq(user_group3.id.to_s)
          end
        end

        describe 'filters' do
          context 'name' do
            let(:user_group_name2) { 'Lorem' }
            let(:'filter[name]') { 'ore' }

            run_test! do
              expect(parsed_json_data.length).to eq(1)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [user_group2.id]
            end
          end

          context 'group_type_id' do
            let(:'filter[group_type_id]') { group_type2.id }

            run_test! do
              expect(parsed_json_data.length).to eq(2)
              expect(parsed_json_data.collect { |e| e['id'].to_i }).to eql [user_group2.id, user_group3.id]
            end
          end
        end
      end
    end
  end
end
