$(document).on('turbo:load', () => {
  const filtersPredefinedRangesMenuSelector = '#filters-predefined-ranges-menu'

  $(`${filtersPredefinedRangesMenuSelector} a`).on('click', (e) => {
    e.preventDefault()

    const predefinedRangesToggleSelector = '#filters-predefined-ranges-toggle'
    const filterStartDateSelector = '#query_filter_start_date'
    const filterEndDateSelector = '#query_filter_end_date'

    const menuItem = $(e.target)

    let rangeBegin = menuItem.data('range-begin')
    let rangeEnd = menuItem.data('range-end')

    let filterStartDateFlatpickr = $(filterStartDateSelector)[0]._flatpickr
    let filterEndDateFlatpickr = $(filterEndDateSelector)[0]._flatpickr

    if(rangeBegin && rangeEnd) {
      filterStartDateFlatpickr.setDate(rangeBegin)
      filterEndDateFlatpickr.setDate(rangeEnd)
    }

    $(predefinedRangesToggleSelector).text(e.target.text)

    menuItem.siblings('.active').removeClass('active')
    menuItem.addClass('active')
  })
})
