import List from 'list.js'

window.addEventListener('turbolinks:load', () => {
  const headers = $('table th').map(function() { return $(this).attr('data-sort'); })
  const table = new List('sortable', {
    valueNames: headers,
    sortFunction: function(a, b, options) {
      a = $(a.elm).find('td.' + options.valueName + ' option[selected]').text()
      b = $(b.elm).find('td.' + options.valueName + ' option[selected]').text()

      if (a === b) {
        return 0;
      } else if (a > b) {
        return 1;
      } else {
        return -1;
      }
    }
  });

  table.sort(headers[0], { order: 'desc' });

  $('#sortable select').change(function(){
    var selection = $(this).val();
    table.sort(selection);
  });
});
