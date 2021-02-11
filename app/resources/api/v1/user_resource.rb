class Api::V1::UserResource < JSONAPI::Resource
  model_name 'User'

  attributes :first_name, :last_name, :email, :admin, :password

  has_many :user_groups, acts_as_set: false, exclude_links: :default
  has_many :memberships, acts_as_set: false, exclude_links: :default

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
      raise JSONAPI::Exceptions::ParameterNotAllowed.new(:admin, detail: 'Admin password change via API is not allowed.')
    end

    super(field_data)
  end

  # HACK: trigger exception if user has some user groups assigned. It follows JSONAPI standards.
  def _replace_to_many_links(relationship_type, relationship_key_values, options)
    if relationship_type == :user_groups && @model.user_groups.any?
      raise JSONAPI::Exceptions::ToManySetReplacementForbidden.new(
        detail: 'User already has user group(s) assigned. Use memberships POST endpoint.'
      )
    end

    super(relationship_type, relationship_key_values, options)
  end

  before_remove do
    raise JSONAPI::Exceptions::RecordLocked, 'Admin user can not be deleted.' and return if @model.admin?
  end
end
