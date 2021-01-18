class Api::V1::UserResource < JSONAPI::Resource
  model_name 'User'

  attributes :first_name, :last_name, :email

  def self.updatable_fields(context)
    super - [:admin]
  end

  def self.creatable_fields(context)
    super - [:admin]
  end

  before_remove do
    raise JSONAPI::Exceptions::RecordLocked.new(detail: 'Admin user can not be deleted.') and return if @model.admin
  end
end
