class Api::V1::TagTypeResource < JSONAPI::Resource
  model_name 'TagType'

  attributes :name, :parent_id, :active_for_activities_at, :active_for_time_ranges_at
end
