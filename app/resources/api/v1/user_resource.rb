class Api::V1::UserResource < JSONAPI::Resource
  model_name 'User'

  attributes :first_name, :last_name, :email, :admin, :password

  has_many :user_groups, acts_as_set: true, exclude_links: :default

  def self.fetchable_fields(_context)
    super - [:password]
  end

  def self.updatable_fields(_context)
    super - [:admin]
  end

  def self.creatable_fields(_context)
    super - [:admin]
  end

  # HACK: do not allow change admin password via API
  def replace_fields(field_data)
    if @model.admin? && @model.persisted? && field_data[:attributes] && field_data[:attributes].include?(:password)
      raise JSONAPI::Exceptions::ParameterNotAllowed, 'Admin password change via API' and return
    end

    super
  end

  before_remove do
    raise JSONAPI::Exceptions::RecordLocked, 'Admin user can not be deleted.' and return if @model.admin?
  end
end
