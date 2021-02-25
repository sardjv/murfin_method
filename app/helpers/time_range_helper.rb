module TimeRangeHelper
  def time_worked(time_range)
    duration_in_words(time_range.value)
  end

  def duration_in_words(value, format = :long)
    hours = (value / 60).floor
    minutes = (value % 60).round
    if minutes == 60 # it may rarely happen when rounding
      hours += 1
      minutes = 0
    end
    hours_and_minutes(hours, minutes, format)
  end

  def hours_and_minutes(hours, minutes, format = :long)
    if format == :short
      return "#{hours}h" if minutes.zero?
      return "#{minutes}m" if hours.zero?

      ["#{hours}h", "#{minutes}m"].join(' ')
    else
      return pluralize(hours, 'hour') if minutes.zero?
      return pluralize(minutes, 'minute') if hours.zero?

      "#{pluralize(hours, 'hour')} and #{pluralize(minutes, 'minute')}"
    end
  end

  # formats date range like: Feb 24th - Mar 1st, by default
  # accepts other date_format param
  def date_range_humanized(range, date_format = :short_ordinal)
    ret = [range.begin.to_s(date_format)]
    if range.begin != range.end
      ret << if range.begin.month == range.end.month
               range.end.day.ordinalize
             else
               range.end.to_s(date_format)
             end
    end
    ret.join(' - ')
  end
end
