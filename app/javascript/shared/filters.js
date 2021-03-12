$(document).on('turbolinks:load', () => {
  const filtersPredefinedMenuSelector = '#filters-predefined-ranges-menu'

  $(`${filtersPredefinedMenuSelector} a`).on('click', (e) => {
    e.preventDefault()

    const filtersPredefinedMenuToggleSelector = '#filters-predefined-ranges-toggle'
    const filterStartDateSelector = '#query_filter_start_date'
    const filterEndDateSelector = '#query_filter_end_date'

    const menuItem = $(e.target)

    let rangeBegin = menuItem.data('range-begin')
    let rangeEnd = menuItem.data('range-end')

    let filterStartDateFlatpickr = $(filterStartDateSelector)[0]._flatpickr
    let filterEndDateFlatpickr = $(filterEndDateSelector)[0]._flatpickr

    filterStartDateFlatpickr.setDate(rangeBegin)
    filterEndDateFlatpickr.setDate(rangeEnd)

    $(filtersPredefinedMenuToggleSelector).text(e.target.text)

    menuItem.siblings('.active').removeClass('active')
    menuItem.addClass('active')

    // TODO here's the place where cookie for filters start/end date can be set
  })
})
