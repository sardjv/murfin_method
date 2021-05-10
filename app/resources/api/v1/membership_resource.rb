class Api::V1::MembershipResource < JSONAPI::Resource
  model_name 'Membership'

  attributes :user_id, :user_epr_uuid, :user_group_id, :role

  attr_accessor :user_epr_uuid

  exclude_links [:self]

  def fetchable_fields
    super - [:user_epr_uuid]
  end

  before_save do
    if user_id.present? && user_epr_uuid.present?
      raise JSONAPI::Exceptions::ParameterNotAllowed.new(user_epr_uuid,
                                                         detail: I18n.t('api.errors.ambiguous_user_identifier'))
    end

    if !@model.user && user_epr_uuid.present?
      user = User.find_by(epr_uuid: user_epr_uuid)
      unless user
        raise JSONAPI::Exceptions::RecordNotFound.new(user_epr_uuid,
                                                      detail: I18n.t('api.errors.invalid_user_epr_uuid',
                                                                     epr_uuid: user_epr_uuid))
      end

      @model.user = user
    end
  end
end
