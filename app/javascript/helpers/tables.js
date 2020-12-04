import List from 'list.js'

window.addEventListener('turbolinks:load', () => {
  const headers = $('table th').map(function() { return $(this).attr('data-sort'); })
  const table = new List('sortable', {
    valueNames: headers
  });

  table.sort(headers[0], { order: 'desc' });
});

