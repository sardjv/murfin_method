class Api::V1::ActivityResource < JSONAPI::Resource
  model_name 'Activity'

  attributes :plan_id, :minutes_per_week, :tag_ids, :schedule_yaml

  has_many :tags, acts_as_set: true, exclude_links: :default

  def fetchable_fields
    super - [:schedule_yaml]
  end

  def self.creatable_fields(_context)
    super - [:minutes_per_week]
  end

  def minutes_per_week
    ((@model.seconds_per_week || 0) / 60).to_i
  end

  def schedule_yaml=(yaml)
    @model.schedule = IceCube::Schedule.from_yaml(yaml)
  end

  exclude_links [:self]

  # disable self_link within resource
  # gets rid of the warning: self_link for Api::V1::ActivityResource could not be generated
  # remove if route for Activity GET added
  def custom_links(_options)
    { self: nil }
  end

  # TODO: move to concern, used also in TimeRanges resource
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
end
