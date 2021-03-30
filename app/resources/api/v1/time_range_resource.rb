class Api::V1::TimeRangeResource < JSONAPI::Resource
  model_name 'TimeRange'

  attributes :start_time, :end_time, :user_id, :user_epr_uuid, :time_range_type_id, :appointment_id
  attribute :minutes_worked, delegate: :value

  has_many :tags, acts_as_set: true, exclude_links: :default

  def minutes_worked
    @model.value.to_i
  end

  def self.fetchable_fields(_context)
    super - [:user_epr_uuid]
  end

  def self.updatable_fields(_context)
    super - [:user_epr_uuid]
  end

  # def self.creatable_fields(_context)
  #   super - [:user_epr_uuid]
  # end

  before_save do
    if @model.user_id.blank? && @model.user_epr_uuid.present?
      user = User.find_by(epr_uuid: @model.user_epr_uuid)

      raise JSONAPI::Exceptions::RecordNotFound.new(@model.user_epr_uuid,
        detail: I18n.t('api.time_range_resource.errors.invalid_user_epr_uuid', epr_uuid: @model.user_epr_uuid)) unless user

      @model.user_id = user.id
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
