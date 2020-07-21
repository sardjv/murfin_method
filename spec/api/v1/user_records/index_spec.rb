require 'swagger_helper'

describe 'Api::V1::User', type: :request, swagger_doc: 'v1/swagger.json' do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let(:response_data) { JSON.parse(response.body)['data'] }

  path '/api/v1/users' do
    get 'user records' do
      tags 'User'
      security [{ JWT: {} }]
      produces 'application/vnd.api+json'
      parameter name: 'page[size]', in: :query, type: :integer, required: false
      parameter name: 'page[number]', in: :query, type: :integer, required: false

      let!(:'page[size]') { 2 }
      let!(:'page[number]') { 1 }

      context 'when a normal user' do
        let(:Authorization) { 'Bearer dummy_json_web_token' }

        response '200', 'successful' do
          schema '$ref' => '#/definitions/users_response'

          describe 'attributes match database values' do
            run_test! do
              expect(response_data.count).to eq(2)
              database_record = User.find(response_data.first['id'])
              response_data.first['attributes'].each do |key, value|
                if database_record.send(key).is_a?(Time)
                  expect(I18n.l(database_record.send(key), format: :iso8601_utc)).to eq(value.to_s)
                else
                  expect(database_record.send(key).to_s).to eq(value.to_s)
                end
              end
            end
          end

          context 'with 1 result per page' do
            let!(:'page[size]') { 1 }
            let!(:'page[number]') { 2 }

            run_test! do
              expect(response_data.first['id']).to eq(user2.id.to_s)
              expect(response_data.first['attributes']['email']).to eq(user2.email)
            end
          end
        end
      end
    end
  end
end
