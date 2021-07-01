shared_examples 'has response bad request' do
  let(:error_title) { 'Param not allowed' } unless method_defined?(:error_title)

  response '400', 'Bad Request' do
    schema '$ref' => '#/definitions/error_400'

    run_test! do
      expect(parsed_json_error[:title]).to eql error_title
      expect(parsed_json_error[:detail]).to eql error_detail
      expect(parsed_json_error[:status]).to eql '400'
    end
  end
end

shared_examples 'has response forbidden' do
  let(:error_title) { 'Forbidden' } unless method_defined?(:error_title)
  let(:error_detail) { 'Forbidden' } unless method_defined?(:error_detail)

  response '403', 'Forbidden' do
    schema '$ref' => '#/definitions/error_403'

    run_test! do
      expect(parsed_json_error[:title]).to eql error_title
      expect(parsed_json_error[:detail]).to eql error_detail
      expect(parsed_json_error[:status]).to eql '403'
    end
  end
end

shared_examples 'has response record not found' do
  let(:id) { 123_456_789 } unless method_defined?(:id)
  let(:error_title) { 'Record not found' } unless method_defined?(:error_title)
  let(:error_detail) { "The record identified by #{id} could not be found." } unless method_defined?(:error_detail)
  let(:error_status) { '404' }
  let(:error_code) { '404' }

  response '404', 'Record not found' do
    schema '$ref' => '#/definitions/error_404'

    run_test! do
      expect(parsed_json_error[:title]).to eql error_title
      expect(parsed_json_error[:detail]).to eql error_detail
      expect(parsed_json_error[:status]).to eql error_status
      expect(parsed_json_error[:code]).to eql error_code
    end
  end
end

shared_examples 'has response unsupported accept header' do
  let(:Accept) { 'application/foobar' }
  let(:error_title) { 'Not acceptable' }
  let(:error_detail) do
    "All requests must use the 'application/vnd.api+json' Accept without media type parameters. This request specified 'application/foobar'."
  end
  let(:error_status) { '406' }
  let(:error_code) { '406' }

  response '406', 'Unsupported accept header' do
    schema '$ref' => '#/definitions/error_406'

    run_test! do
      expect(parsed_json_error[:title]).to eql error_title
      expect(parsed_json_error[:detail]).to eql error_detail
      expect(parsed_json_error[:status]).to eql error_status
      expect(parsed_json_error[:code]).to eql error_code
    end
  end
end

shared_examples 'has response unprocessable entity' do
  let(:error_status) { '422' }
  let(:error_code) { '100' } unless method_defined?(:error_code)

  response '422', 'Unprocessable Entity' do
    schema '$ref' => '#/definitions/error_422'

    run_test! do
      expect(parsed_json_error[:title]).to eql error_title
      expect(parsed_json_error[:detail]).to eql error_detail
      expect(parsed_json_error[:status]).to eql error_status
      expect(parsed_json_error[:code]).to eql error_code
    end
  end
end
