module JWTAuthorizationStub
  RSpec.configure do |config|
    config.before do |example|
      if self.class.name.include?('Api') && !example.metadata[:skip_jwt_authorization_stub]
        api_user = create :api_user
        allow_any_instance_of(SecuredWithToken).to receive(:authenticate_request!).and_return(api_user)
      end
    end
  end
end

RSpec.configure do |config|
  config.include JWTAuthorizationStub, type: :request
end
