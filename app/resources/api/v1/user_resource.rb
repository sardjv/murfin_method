class Api::V1::UserResource < JSONAPI::Resource
  model_name 'User'

  attributes :first_name, :last_name, :email, :admin, :password

  def self.fetchable_fields(_context)
    super - [:password]
  end

  def self.updatable_fields(_context)
    super - [:admin]
  end

  def self.creatable_fields(_context)
    super - [:admin]
  end

  # before_update do
  #   if @model.admin? # TODO: && check if password passed
  #     raise JSONAPI::Exceptions::ParameterNotAllowed, 'Admin password change not allowed via API.' and return
  #   end
  # end

  before_remove do
    raise JSONAPI::Exceptions::RecordLocked, 'Admin user can not be deleted.' and return if @model.admin?
  end
end
