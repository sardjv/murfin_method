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
        borderWidth: 1,
        fill: false,
        borderColor: '#8CC6F4',
        borderWidth: 5,
        pointRadius: 0.0001,
        pointHitRadius: 200,
        lineTension: 0.3,
        borderCapStyle: 'round'
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
