import Chart from 'chart.js'
import Rails from '@rails/ujs'

window.addEventListener('turbolinks:load', () => {
  Rails.ajax({
    url: data_url(),
    type: 'GET',
    success: function(data) {
      bar_chart(document.getElementById('bar-chart'), data.bar_chart)
    }
  });
});

function bar_chart(context, data) {
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

  new Chart(context, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        barPercentage: 0.4,
        data: values,
        backgroundColor: colors,
        borderColor: colors,
        borderWidth: 1
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
              return value + '%'
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
