module RequestSpecHelper
  def parsed_json
    JSON.parse(response.body)
  end

  def parsed_json_data
    parsed_json['data']
  end

  def parsed_json_data_matches_db_record(db_record, data = nil) # rubocop:disable Metrics/AbcSize
    data ||= parsed_json_data

    expect(data['id']).to eql db_record.id.to_s # because attributes do not contain id

    data['attributes'].each do |key, value|
      if db_record.send(key).is_a?(Time)
        time_formatted = I18n.l(db_record.send(key), format: :iso8601_utc)
        expect(time_formatted).to eq(value.to_s)
      else
        expect(db_record.send(key).to_s).to eq(value.to_s)
      end
    end
  end
end

RSpec.configure do |config|
  config.include RequestSpecHelper, type: :request
end
