module Api
  module V1
    class UserResource < JSONAPI::Resource
      immutable # Remove POST and PUT endpoints.

      model_name 'User'

      attributes :first_name, :last_name, :email
    end
  end
end
