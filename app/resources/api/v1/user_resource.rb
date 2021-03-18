class Api::V1::UserResource < JSONAPI::Resource
  model_name 'User'

  attributes :first_name, :last_name, :email, :epr_uuid, :admin, :password

  has_many :user_groups, exclude_links: :default
  has_many :memberships, exclude_links: :default

  def epr_uuid=(val)
    @model.epr_uuid = val || ''
  end

  filter :email,
         apply: lambda { |records, values, _options|
           records.where(email: values[0])
         }

  filter :epr_uuid,
         apply: lambda { |records, values, _options|
           records.where(epr_uuid: values[0])
         }

  def self.fetchable_fields(_context)
    super - [:password]
  end

  def self.updatable_fields(_context)
    super - [:admin]
  end

  def self.creatable_fields(_context)
    super - [:admin]
  end

  def replace_fields(field_data)
    # HACK: do not allow change admin password via API
    if @model.admin? && @model.persisted? && field_data[:attributes] && field_data[:attributes].include?(:password)
      raise JSONAPI::Exceptions::ParameterNotAllowed.new(:password,
                                                         detail: I18n.t('api.user_resource.errors.admin_password_change'))
    end

    super(field_data)
  end

  def _replace_to_many_links(relationship_type, relationship_key_values, options)
    # HACK: trigger exception if user has some user groups assigned. It follows JSONAPI standards.
    if relationship_type == :user_groups && @model.user_groups.any?
      raise JSONAPI::Exceptions::ToManySetReplacementForbidden.new(
        detail: I18n.t('api.user_resource.errors.user_has_user_groups')
      )
    end

    # HACK: trigger exception if any of user groups to assign does not exist
    if relationship_type == :user_groups && relationship_key_values.any?
      invalid_ids = relationship_key_values - UserGroup.where(id: relationship_key_values).pluck(:id)

      if invalid_ids.any?
        raise JSONAPI::Exceptions::RecordNotFound.new(invalid_ids,
                                                      detail: I18n.t('api.user_resource.errors.invalid_user_groups', count: invalid_ids.count,
                                                                                                                     invalid_ids: invalid_ids.join(', '))) # rubocop:disable Layout/LineLength
      end
    end

    super(relationship_type, relationship_key_values, options)
  end

  before_remove do
    raise JSONAPI::Exceptions::RecordLocked.new(details: I18n.t('api.user_resource.errors.admin_delete')) and return if @model.admin?
  end
end
