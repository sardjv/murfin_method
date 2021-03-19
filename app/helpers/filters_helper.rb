# frozen_string_literal: true

module FiltersHelper
  def filters_predefined_ranges_options # rubocop:disable Metrics/AbcSize
    [
      {
        range: [],
        label: t('filters.predefined_ranges.custom')
      },
      {
        range: [2.months.ago.beginning_of_month.to_date, Date.current.end_of_month],
        label: t('filters.predefined_ranges.last_3_months')
      },
      {
        range: [5.months.ago.beginning_of_month.to_date, Date.current.end_of_month],
        label: t('filters.predefined_ranges.last_6_months')
      },
      {
        range: [11.months.ago.beginning_of_month.to_date, Date.current.end_of_month],
        label: t('filters.predefined_ranges.last_12_months')
      }
    ]
  end

  def filters_predefined_ranges_toogle_anchor(start_date, end_date)
    selected_option = filters_predefined_ranges_find_option(start_date, end_date)

    (selected_option || filters_predefined_ranges_options.first).try(:[], :label)
  end

  def filters_predefined_ranges_option_is_selected(start_date, end_date, option_range)
    (start_date == option_range[0] && end_date == option_range[1]) ||
    (option_range.blank? && !filters_predefined_ranges_find_option(start_date, end_date))
  end

  private

  def filters_predefined_ranges_find_option(start_date, end_date)
    filters_predefined_ranges_options.detect {|h| h[:range][0] == start_date && h[:range][1] == end_date }
  end
end
