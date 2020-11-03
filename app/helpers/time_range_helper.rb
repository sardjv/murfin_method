module TimeRangeHelper
  def time_worked(time_range)
    duration_in_words(time_range.value.minutes)
  end

  def duration_in_words(value)
    time_ago_in_words(Time.current + value)
  end
end
