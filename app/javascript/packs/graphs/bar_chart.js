import * as d3 from 'd3'
import * as c3 from 'c3'

window.addEventListener('turbolinks:load', () => {
  var values = [
    'Actual vs Plan',
    "88",
    "87",
    "82",
    "79",
    "72",
    "68",
    "64",
    "60",
    "53",
    "53",
    "53",
  ]

  var names = [
    "Skylar Assaqd",
    "Angel George",
    "Gretchen Botosh",
    "Marcus Bator",
    "Brandon Vetrov",
    "Philip Philips",
    "Jordyn Korsgaard",
    "Mira Korsgaard",
    "Ann Herwitz",
    "Jaylon Dokidis",
    "Chance Torff",
  ]

  var chart = c3.generate({
    bindto: '#bar-chart',
    data: {
      columns: [
        values
      ],
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
        categories: names
      }
    }
  });
});
