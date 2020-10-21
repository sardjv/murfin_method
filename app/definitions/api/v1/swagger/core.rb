class Api::V1::Swagger::Core
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
      Api::V1::Swagger::User.definitions
    ]
  end
end
