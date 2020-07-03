import Chart from 'chart.js'
import Rails from '@rails/ujs'
import { API } from './api'
import { MissingData } from './missing_data'
import * as SCSSColours from '!!sass-variable-loader!../stylesheets/colours.scss';

window.addEventListener('turbolinks:load', () => {
  var context
  if (context = document.getElementById('bar-chart')) {
    Rails.ajax({
      url: API.url(),
      type: 'GET',
      success: function(data) {
        bar_chart(context, data.bar_chart)
      }
    });
  }
});

function bar_chart(context, data) {
  var style = getComputedStyle(document.body);

  var colours = data.map(function(e) {
    var val = e.value;

    if (val == null) {
      return SCSSColours['purple50'];
    } else if (val >= 120) {
      // Over.
      return SCSSColours['red50'];
    } else if (val >= 80) {
      // About right.
      return SCSSColours['green50'];
    } else if (val >= 50) {
      // Under.
      return SCSSColours['yellow200'];
    } else {
      // Really Under.
      return SCSSColours['blue50'];
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

  var fallback = MissingData.generate(data);
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
        backgroundColor: colours,
        borderColor: colours,
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
