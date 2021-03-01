class Api::V1::ActivityResource < JSONAPI::Resource
  model_name 'Activity'
  immutable

  attributes :plan_id, :minutes_per_week, :tag_ids

  # disable self_link within resource
  # gets rid of the warning: self_link for Api::V1::ActivityResource could not be generated
  # remove if route for Activites added
  def custom_links(_options)
    { self: nil }
  end

  def minutes_per_week
    ((@model.seconds_per_week || 0) / 60).to_i
  end
end
