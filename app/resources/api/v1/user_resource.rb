class Api::V1::UserResource < JSONAPI::Resource
  immutable # Remove POST and PUT endpoints.

  model_name 'User'

  attributes :name, :email
end
