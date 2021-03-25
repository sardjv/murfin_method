module ActivitiesHelper

  def calculate_hours_per_week_for_tag(tag)
    @activities.tagged_with(tag).sum(&:seconds_per_week) / 60
  end
end
