import * as c3 from 'c3'

window.addEventListener('turbolinks:load', () => {
  var data = [
    { "name": "Skylar Assaqd", "value": "88" },
    { "name": "Angel George", "value": "87" },
    { "name": "Gretchen Botosh", "value": "82" },
    { "name": "Marcus Bator", "value": "79" },
    { "name": "Brandon Vetrovs", "value": "72"},
    { "name": "Philip Philips", "value": "68" },
    { "name": "Jordyn Korsgaard", "value": "64" },
    { "name": "Mira Korsgaard", "value": "60" },
    { "name": "Ann Herwitz", "value": "53" },
    { "name": "Jaylon Dokidis", "value": "53" },
    { "name": "Chance Torff", "value": "53" },
  ]

  c3.generate({
    bindto: '#bar-chart',
    data: {
      json: data,
      keys: {
        value: ['value']
      },
      type: 'bar',
      colors: {
        value: function(d) {
          var val = d.value;
          if (val == null) {
            // Unknown.
            return '#F6E6EE'
          } else if (val > 120) {
            // Over.
            return '#F9DDCE'
          } else if (val >= 80) {
            // About right.
            return '#DBE9C4'
          } else if (val >= 70) {
            // Slightly under.
            return '#E2F1FC'
          } else if (val >= 60) {
            // Under.
            return '#FDF2AA'
          } else {
            // Really under.
            return '#AE4C1A'
          }
        }
      },
    },
    bar: {
      width: {
        ratio: 0.30 // this makes bar width 75% of length between ticks
      }
    },
    legend: {
      show: false
    },
    axis: {
      x: {
        type: 'category',
        categories: data.map(function(o){return o['name']})
      }
    }
  });
});
