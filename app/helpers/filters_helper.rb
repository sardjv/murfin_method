# frozen_string_literal: true

module FiltersHelper
  def filters_predefined_ranges # rubocop:disable Metrics/AbcSize
    [
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
end
