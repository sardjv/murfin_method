import Chart from 'chart.js'

window.addEventListener('turbolinks:load', () => {
  var data = [
    { "name": "May", "value": "50" },
    { "name": "June", "value": "60" },
    { "name": "July", "value": "70" },
    { "name": "August", "value": "80" },
    { "name": "September", "value": "80"},
    { "name": "October", "value": "120" },
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

  // Set colors of line based on values.
  var width = window.innerWidth || document.body.clientWidth;
  var gradientStroke = ctx.getContext('2d').createLinearGradient(0, 0, width, 0);
  var fraction = 1.0 / (values.length - 1)
  var location = 0
  var i;
  for (i = 0; i < colors.length; i++) {
    gradientStroke.addColorStop(location, colors[i]);
    location += fraction;
  }

  new Chart(ctx, {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        data: values,
        borderWidth: 1,
        fill: false,
        borderColor:               gradientStroke,
        pointBorderColor:          gradientStroke,
        pointBackgroundColor:      gradientStroke,
        pointHoverBackgroundColor: gradientStroke,
        pointHoverBorderColor:     gradientStroke
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
