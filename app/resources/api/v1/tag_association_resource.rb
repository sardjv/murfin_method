class Api::V1::TagAssociationResource < JSONAPI::Resource
  model_name 'TagAssociation'

  attributes :tag_id, :tag_type_id, :taggable_id, :taggable_type, :time_range_appointment_id

  attr_writer :time_range_appointment_id

  def fetchable_fields
    super - [:time_range_appointment_id]
  end

  before_save do
    if !@model.taggable && @time_range_appointment_id.present?
      time_range = TimeRange.find_by(appointment_id: @time_range_appointment_id)

      unless time_range
        raise JSONAPI::Exceptions::RecordNotFound.new(
          @time_range_appointment_id,
          detail: I18n.t('api.tag_association_resource.errors.invalid_time_range_appointment_id',
                         appointment_id: @time_range_appointment_id)
        )
      end

      @model.taggable = time_range
    end
  end
end
