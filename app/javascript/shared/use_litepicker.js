import { format, toDate, subMonths, startOfMonth, endOfMonth, startOfYear, endOfYear } from 'date-fns'

const useLitepicker = (input) => {
  const defStartDate = input.getAttribute('data-filter-start-date')
  const defEndDate = input.getAttribute('data-filter-end-date')

  const today = new Date()

  const startOfCurrentMonth = startOfMonth(today)
  const endOfCurrentMonth = endOfMonth(today)

  const threeMonthsAgo = subMonths(startOfCurrentMonth, 2)
  const sixMonthsAgo = subMonths(startOfCurrentMonth, 5)
  const twelveMonthsAgo = subMonths(startOfCurrentMonth, 11)

  const dbFormat = 'yyyy-MM-dd'
  const monthYearFormat = 'MMM YYYY'

  const picker = new Litepicker({
    element: input,
    format: monthYearFormat,
    startDate: defStartDate,
    endDate: defEndDate,
    numberOfMonths: 2,
    numberOfColumns: 2,
    singleMode: false, // Choose a single date instead of a date range.
    scrollToDate: false, // Scroll to start date on open.
    splitView: true, // Enable the previous and the next button for each month.
    allowRepick: true,
    autoRefresh: true,
    autoApply: true,
    showTooltip: false,
    selectForward: true,
    plugins: ['ranges'],
    dropdowns: { minYear: today.getFullYear() - 10, maxYear: today.getFullYear(), months: true, years: true },
    lockDaysFilter: (day) => {
      const date = day.dateInstance

      let month_start = startOfMonth(date)
      let month_end = endOfMonth(date)

      return (format(date, dbFormat) != format(month_start, dbFormat)) &&
             (format(date, dbFormat) != format(month_end, dbFormat))
    },
    ranges: {
      customRanges: {
        'last 3 months': [threeMonthsAgo, endOfCurrentMonth],
        'last 6 months': [sixMonthsAgo, endOfCurrentMonth],
        'last 12 months': [twelveMonthsAgo, endOfCurrentMonth]
      },
      position: 'right',
      autoApply: true
    },
    setup: (picker) => {
      picker.on('show', () => { // TODO hack to fix end date selection, remove when Litepicker fixed version released
        picker.gotoDate(picker.options.startDate, 0)
        picker.gotoDate(picker.options.endDate, 1)
      }),

      picker.on('change:month', (date, calendarIdx) => {
        let startDate = picker.getStartDate() ? picker.getStartDate().dateInstance : startOfCurrentMonth
        let endDate = picker.getEndDate() ? picker.getEndDate().dateInstance : endOfMonth(startDate)

        let selected_date = new Date(date.dateInstance)

        if(calendarIdx == 0) {
          startDate = startOfMonth(selected_date)
        } else if (calendarIdx == 1) {
          endDate = endOfMonth(selected_date)
        }

        picker.setDateRange(startDate, endDate, true)
        picker.gotoDate(picker.getStartDate(), 0)
      })

      picker.on('change:year', (date, calendarIdx) => {
        //picker.clearSelection()

        let startDate = picker.getStartDate()
        let endDate = picker.getEndDate()

        let selected_date = new Date(date.dateInstance)

        if(calendarIdx == 0) {
          startDate = format(startOfYear(selected_date), dbFormat)
        } else if (calendarIdx == 1) {
          endDate = format(endOfYear(selected_date), dbFormat)
        }

        picker.setDateRange(startDate, endDate, true)
      })
    }
  })
}

$(document).on('turbolinks:load', () => {
  const filterDateRangeSelector = '#query_filter_date_range'
  const el = $(filterDateRangeSelector)

  if(el.length > 0) {
    useLitepicker(el[0])
  }
})