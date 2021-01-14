module TimeRangeHelper
  def time_worked(time_range)
    duration_in_words(time_range.value)
  end

  def duration_in_words(value)
    hours = (value / 60).floor
    minutes = (value % 60).round
    hours_and_minutes(hours, minutes)
  end

  def hours_and_minutes(hours, minutes)
    return pluralize(hours, 'hour') if minutes.zero?
    return pluralize(minutes, 'minute') if hours.zero?

    "#{pluralize(hours, 'hour')} and #{pluralize(minutes, 'minute')}"
  end
end
