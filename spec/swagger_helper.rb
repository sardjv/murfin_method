require 'rails_helper'
require './swagger/v1/errors'
require './swagger/v1/users'
require './swagger/v1/time_ranges'

class Swagger::V1::Core
  def self.docs
    {
      'v1/swagger.json' => {
        swagger: '2.0',
        info: {
          title: 'Murfin+ API',
          version: 'v1',
          description: 'This is the Murfin+ API. For more information visit
                        <a href="https://github.com/sardjv/murfin_method">
                        github.com/sardjv/murfin_method</a>.'
        },
        securityDefinitions: {
          JWT: {
            description: 'The JSON Web Token from Auth0 for authentication.',
            type: :apiKey,
            name: 'Authorization',
            in: :header
          }
        },
        paths: {},
        definitions: definitions.inject(&:merge)
      }
    }
  end

  def self.definitions
    [
      Swagger::V1::TimeRanges.definitions,
      Swagger::V1::Users.definitions,
      Swagger::V1::Errors.definitions
    ]
  end
end

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = Swagger::V1::Core.docs
end
