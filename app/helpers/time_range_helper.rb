module TimeRangeHelper
  def time_worked(time_range)
    time_ago_in_words(Time.current + time_range.value.minutes)
  end
end
