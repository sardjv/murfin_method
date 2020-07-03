import Chart from 'chart.js'
import Rails from '@rails/ujs'

window.addEventListener('turbolinks:load', () => {
  var context
  if (context = document.getElementById('bar-chart')) {
    Rails.ajax({
      url: data_url(),
      type: 'GET',
      success: function(data) {
        bar_chart(context, data.bar_chart)
      }
    });
  }
});

function bar_chart(context, data) {
  var colors = data.map(function(e) {
    var val = e.value;

    if (val == null) {
      // Unknown.
      return '#EDE2F0'
    } else if (val >= 120) {
      // Over.
      return '#F9DDCE'
    } else if (val >= 80) {
      // About right.
      return '#F0F7E7'
    } else if (val >= 50) {
      // Under.
      return '#FDF2AA'
    } else {
      // Really Under.
      return '#E2F1FC'
    }
  });
  var labels = data.map(function(e) {
    if (e.value) {
      return e.name;
    } else {
      return e.name + ' ?'
    }
  });

  var toolTips = data.map(function(e) {
    if (e.value) {
      return e.value + '%';
    } else {
      return 'No data';
    }
  });

  var fallback = missingDataVal(data);
  var values = data.map(function(e) {
    return e.value || fallback;
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
          label: function(tooltipItem, _data) {
            return toolTips[tooltipItem.index];
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
