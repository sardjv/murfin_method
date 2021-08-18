class Api::V1::TimeRangeResource < JSONAPI::Resource
  model_name 'TimeRange'

  attributes :start_time, :end_time, :user_id, :user_epr_uuid, :time_range_type_id, :appointment_id
  attribute :minutes_worked, delegate: :value

  has_many :tags, acts_as_set: true, exclude_links: :default

  attr_accessor :user_epr_uuid

  def minutes_worked
    @model.value.to_i
  end

  def fetchable_fields
    super - [:user_epr_uuid]
  end

  # HACK: set 404 exception if some of the tags to assign not found
  def _replace_to_many_links(relationship_type, relationship_key_values, options)
    tag_ids = relationship_key_values
    if relationship_type == :tags && relationship_key_values.present?
      tag_ids = relationship_key_values
      tag_ids_found = Tag.where(id: tag_ids).pluck(:id)

      if tag_ids.count != tag_ids_found.count
        invalid_ids = tag_ids - tag_ids_found

        raise JSONAPI::Exceptions::RecordNotFound.new(invalid_ids,
                                                      detail: I18n.t('api.time_range_resource.errors.invalid_tags', count: invalid_ids.count,
                                                                                                                    invalid_ids: invalid_ids.join(', '))) # rubocop:disable Layout/LineLength
      end
    end

    super(relationship_type, relationship_key_values, options)
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

  filter :appointment_id,
         apply: lambda { |records, values, _options|
           records.where(appointment_id: values[0])
         }

  filter :user_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(user_id: values[0])
         }

  filter :time_range_type_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(time_range_type_id: values[0])
         }
end
