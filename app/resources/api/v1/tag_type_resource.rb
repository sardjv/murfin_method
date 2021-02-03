class Api::V1::TagTypeResource < JSONAPI::Resource
  model_name 'TagType'

  attributes :name, :parent_id, :active_for_activities_at, :active_for_time_ranges_at

  before_remove do
    if @model.tags.joins(:tag_associations).any?
      raise JSONAPI::Exceptions::RecordLocked,
            'Cannot delete record because dependent tag associations exist.'
    end
  end
end
