import Chart from 'chart.js'
import Rails from '@rails/ujs'
import { API } from './api'
import * as SCSSColours from '!!sass-variable-loader!../stylesheets/variables/colours.scss';

window.addEventListener('turbolinks:load', () => {
  const context = document.getElementById('line-graph');
  if (context) {
    Rails.ajax({
      url: API.url(),
      type: 'GET',
      success: function(data) {
        const units = data.line_graph.units
        line_graph(context, data.line_graph)
      }
    });
  }
});

function getColour(number) {
  const colours = [
    'blue400',
    'purple200',
    'orange600',
    'yellow500',
    'green400',
    'red600',
    'blue800',
    'purple600',
    'orange200',
    'yellow200',
    'green800',
    'red200'
  ]

  return SCSSColours[colours[number]]
}

function datasets(datas) {
  let index = 0;
  return datas.map(function(data) {
    const dataset = {
      data: data.map(function(e) {
        return e.value;
      }),
      borderWidth: 1,
      fill: false,
      backgroundColor: getColour(index),
      borderColor: getColour(index),
      borderWidth: 5,
      pointRadius: 0.0001,
      pointHitRadius: 20,
      lineTension: 0.3,
      borderCapStyle: 'round'
    }
    index += 1;
    return dataset;
  });
}

function line_graph(context, line_graph) {
  const originalLabels = line_graph.data[0].map(function(e) {
    return e.name;
  });
  const formattedLabels = line_graph.data[0].map(function(e) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][new Date(Date.parse(e.name)).getMonth()];
  });

  var units = line_graph.units || ''

  new Chart(context, {
    type: 'line',
    data: {
      labels: formattedLabels,
      originalLabels: originalLabels,
      datasets: datasets(line_graph.data),
      units: units
    },
    options: {
      legend: {
        display: false
      },
      tooltips: {
        callbacks: {
          label: function(tooltipItem, data) {
            return tooltipItem.value + data.units;
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
              return value + units
            }
          }
        }]
      },
      onClick: (_event, elements) => {
        if(elements[0]) {
          $('#modal').modal()
          console.log(elements[0]._chart.data.originalLabels[elements[0]._index])
        }
      }
    }
  });
}
