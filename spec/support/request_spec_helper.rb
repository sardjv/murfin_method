module RequestSpecHelper
  def parsed_json
    JSON.parse(response.body)
  end

  def parsed_json_data
    parsed_json['data']
  end

  def parsed_json_data_matches_db_values(db_record)
    expect(parsed_json_data['id']).to eql db_record.id.to_s # because attributes does not contain id

    parsed_json_data['attributes'].each do |key, value|
      if db_record.send(key).is_a?(Time)
        expect(I18n.l(db_record.send(key), format: :iso8601_utc)).to eq(value.to_s)
      else
        expect(db_record.send(key).to_s).to eq(value.to_s)
      end
    end
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end
