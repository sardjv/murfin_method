module ActivitiesHelper
  def activities_hours_per_week_for_tag(activities, tag)
    activities.tagged_with(tag).sum(&:seconds_per_week) / 60
  end
end
