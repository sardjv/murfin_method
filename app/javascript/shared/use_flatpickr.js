import flatpickr from 'flatpickr'
require('flatpickr/dist/flatpickr.css')

import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect'
require('flatpickr/dist/plugins/monthSelect/style.css')

const useFlatpickrSelector = 'input[data-behaviour-flatpickr]'

const flatpickrOnChange = (_selectedDates, _dateStr, _instance) => {
  const predefinedRangesToggleSelector = '#filters-predefined-ranges-toggle'
  const predefinedRangesMenuSelector = '#filters-predefined-ranges-menu'
  const hasPredefinedRanges = $(predefinedRangesToggleSelector).length > 0
  if(!hasPredefinedRanges) {
    return
  }

  // set predefined ranges toogle to option Custom
  $(predefinedRangesToggleSelector).text('Custom')
  $(`${predefinedRangesMenuSelector} .dropdown-item`).removeClass('active')
  $(`${predefinedRangesMenuSelector} .dropdown-item:first`).addClass('active')
}

const flatpickrOnValueUpdate = (selectedDates, _dateStr, instance) => {
  if(instance.element.id.match(/.*_end_date/)) { // for field which contains id with _end_date set last day of month
    let end_date_start_of_month = selectedDates[0]
    let year = end_date_start_of_month.getFullYear()
    let month = end_date_start_of_month.getMonth()

    const end_date_end_of_month = new Date(year, month + 1, 0)
    instance.setDate(end_date_end_of_month, false)
  }
}

const useFlatpickr = () => {
  const flatpickrConfig = {
    allowInput: false,
    altInput: true,
    onChange: flatpickrOnChange,
    onValueUpdate: flatpickrOnValueUpdate,
    plugins: [
      new monthSelectPlugin({
        shorthand: true,
        altFormat: 'M Y',
        dateFormat: 'Y-m-d'
      })
    ]
  }

  flatpickr(useFlatpickrSelector, flatpickrConfig)
}

document.addEventListener('turbo:load', () => { useFlatpickr()} )
document.addEventListener('turbo:render', () => { useFlatpickr()} )

document.addEventListener('turbo:before-cache', () => {
  $(useFlatpickrSelector).each(function() {
    $(this).flatpickr().destroy()
  })
})