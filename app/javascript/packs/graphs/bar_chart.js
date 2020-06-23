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
    padding: {
      top: 20,
      bottom: 100
    },
    data: {
      json: data,
      keys: {
        value: ['value']
      },
      type: 'bar'
    },
    bar: {
      width: {
        ratio: 0.75 // this makes bar width 75% of length between ticks
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
