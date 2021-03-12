import flatpickr from 'flatpickr'
require('flatpickr/dist/flatpickr.css')

import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect'
require('flatpickr/dist/plugins/monthSelect/style.css')

$(document).on('turbolinks:load', () => {
  const useFlatpickrSelector = 'input[data-behaviour-flatpickr]'

  const flatpickrConfig = {
    allowInput: false,
    altInput: true,
    //altInputClass: 'filters-date-alt-input',
    plugins: [
        new monthSelectPlugin({
          shorthand: true,
          altFormat: 'M Y',
          dateFormat: 'Y-m-d'
        })
    ]
    // onChange: function(selectedDates, dateStr, instance) {
    //   console.log(selectedDates)
    //   console.log(dateStr)
    // }
  }

  flatpickr(useFlatpickrSelector, flatpickrConfig)
})
