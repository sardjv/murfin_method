import Chart from 'chart.js'
import Rails from '@rails/ujs'

window.addEventListener('turbolinks:load', () => {
  var context;
  if (context = document.getElementById('line-graph')) {
    Rails.ajax({
      url: data_url(),
      type: 'GET',
      success: function(data) {
        line_graph(context, data.line_graph)
      }
    });
  }
});

function datasets(datas) {
  return datas.map(function(data) {
    return {
      data: data.map(function(e) {
        return e.value;
      }),
      borderWidth: 1,
      fill: false,
      backgroundColor: '#8CC6F4',
      borderColor: '#8CC6F4',
      borderWidth: 5,
      pointRadius: 0.0001,
      pointHitRadius: 200,
      lineTension: 0.3,
      borderCapStyle: 'round'
    }
  });
}

function line_graph(context, datas) {
  var labels = datas[0].map(function(e) {
    return e.name;
  });

  new Chart(context, {
    type: 'line',
    data: {
      labels: labels,
      datasets: datasets(datas)
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
