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
      return '#F5F5F5'
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

function data_url() {
  if (window.location.pathname == '/') {
    // Can't call root/.json.
    return '/pages/home.json'
  } else {
    return window.location.pathname + '.json'
  }
}

// Value for missing data.
// Based on min and max data (so it shows up), not too
// small, but also not too big.
function missingDataVal(data) {
  var min = getMinimum(data)
  var max = getMaximum(data)
  return ((max - min) * 0.25) + min
}

function getMinimum(data) {
  var min = null;
  data.forEach(function(e) {
    if (e.value != null && (min == null || e.value < min)) {
      min = e.value;
    }
  });
  return min;
}

function getMaximum(data) {
  var max = null;
  data.forEach(function(e) {
    if (e.value != null && (max == null || e.value > max)) {
      max = e.value;
    }
  });
  return max;
}
