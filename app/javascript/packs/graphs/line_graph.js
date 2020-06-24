import Chart from 'chart.js'

window.addEventListener('turbolinks:load', () => {
  var data = [
    { "name": "May", "value": "23" },
    { "name": "June", "value": "50" },
    { "name": "July", "value": "75" },
    { "name": "August", "value": "48" },
    { "name": "September", "value": "95"},
    { "name": "October", "value": "22" },
  ]

  var ctx = document.getElementById('line-graph');
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
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        data: values,
        backgroundColor: colors,
        borderColor: colors,
        borderWidth: 1,
        fill: false
      }]
    },
    options: {
      legend: {
        display: false
      },
      tooltips: {
        callbacks: {
          label: function(tooltipItem, data) {
            return tooltipItem.value + '%';
          }
        }
      },
      scales: {
        xAxes: [{
          gridLines: {
            display: false
          }
        }],
        yAxes: [{
          gridLines: {
            borderDash: [7, 7],
            drawBorder: false
          },
          ticks: {
            stepSize: 10,
            callback: function(value) {
              return value + "%"
            }
          }
        }]
      }
    }
  });
});
