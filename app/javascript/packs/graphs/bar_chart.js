import Chart from 'chart.js'

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

  var ctx = document.getElementById('bar-chart');
  var colors = data.map(function(e) {
    var val = e.value;

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
  });
  var labels = data.map(function(e) {
    return e.name;
  });
  var values = data.map(function(e) {
    return e.value;
  });

  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        barPercentage: 0.5,
        data: values,
        backgroundColor: colors,
        borderColor: colors,
        borderWidth: 1
      }]
    },
    options: {
      legend: {
        display: false
      }
    }
  });
});
