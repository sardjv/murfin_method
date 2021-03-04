Date::DATE_FORMATS[:short_ordinal] = ->(date) { date.strftime("%b #{date.day.ordinalize}") } # add format like: Feb 24th
