import Chart from 'chart.js'
import Rails from '@rails/ujs'

window.addEventListener('turbolinks:load', () => {
  Rails.ajax({
    url: window.location.pathname + '.json',
    type: 'GET',
    success: function(data) {
      data = data.bar_chart
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
  });
});
