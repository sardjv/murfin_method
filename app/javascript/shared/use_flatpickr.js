import flatpickr from 'flatpickr'
require('flatpickr/dist/flatpickr.css')

import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect'
require('flatpickr/dist/plugins/monthSelect/style.css')

const useFlatpickrSelector = 'input[data-behaviour-flatpickr]'

const useFlatpickr = () => {
  const predefinedRangesToggleSelector = '#filters-predefined-ranges-toggle'
  const predefinedRangesMenuSelector = '#filters-predefined-ranges-menu'

  const flatpickrConfig = {
    allowInput: false,
    altInput: true,
    onChange: function(_selectedDates, _dateStr, _instance) {
      // set predefined ranges toogle to option Custom
      $(predefinedRangesToggleSelector).text('Custom')
      $(`${predefinedRangesMenuSelector} .dropdown-item`).removeClass('active')
      $(`${predefinedRangesMenuSelector} .dropdown-item:first`).addClass('active')
    },
    onValueUpdate: function(selectedDates, _dateStr, instance) {
      if(instance.element.id == 'query_filter_end_date') { // for end date set last day of month
        let end_date_start_of_month = selectedDates[0]
        let year = end_date_start_of_month.getFullYear()
        let month = end_date_start_of_month.getMonth()

        const end_date_end_of_month = new Date(year, month + 1, 0)
        instance.setDate(end_date_end_of_month, false)
      }
    },
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

document.addEventListener('turbolinks:load', () => useFlatpickr() )

document.addEventListener('turbolinks:before-cache', () => {
  $(useFlatpickrSelector).each(function() {
    $(this).flatpickr().destroy()
  })
})