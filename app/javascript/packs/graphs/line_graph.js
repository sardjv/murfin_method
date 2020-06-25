import Chart from 'chart.js'
import Rails from '@rails/ujs'

window.addEventListener('turbolinks:load', () => {
  Rails.ajax({
    url: data_url(),
    type: 'GET',
    success: function(data) {
      line_graph(document.getElementById('line-graph'), data.line_graph)
    }
  });
});

function line_graph(context, data) {
  var labels = data.map(function(e) {
    return e.name;
  });
  var values = data.map(function(e) {
    return e.value;
  });

  new Chart(context, {
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
}

function data_url() {
  if (window.location.pathname == '/') {
    // Can't call root/.json.
    return '/pages/home.json'
  } else {
    return window.location.pathname + '.json'
  }
}
