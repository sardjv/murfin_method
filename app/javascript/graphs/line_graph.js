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
        global.chart = line_graph(context, data.line_graph)
      }
    });
  }
});

window.addEventListener('ajax:success', (event) => {
  const [_data, _status, xhr] = event.detail;
  const response = JSON.parse(xhr.response)

  addNotePoint(response.start_time, response.id)

  $('#modal').modal('hide')
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
      note_ids: data.map(function(e) {
        return e.note_id;
      }),
      borderWidth: 1,
      fill: false,
      backgroundColor: getColour(index),
      borderColor: getColour(index),
      borderWidth: 5,
      lineTension: 0.3,
      borderCapStyle: 'round',
      pointHitRadius: 20,
      pointBackgroundColor: SCSSColours['red200'],
      pointBorderColor: SCSSColours['red200'],
      pointHoverBackgroundColor: SCSSColours['red200'],
      pointHoverBorderColor: SCSSColours['red200'],
      pointHoverRadius: 10
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

  return new Chart(context, {
    type: 'line',
    data: {
      labels: formattedLabels,
      originalLabels: originalLabels,
      datasets: datasets(line_graph.data),
      units: units
    },
    options: {
      legend: {
        display: false,
        onHover: function(e) {
          e.target.style.cursor = 'pointer';
        }
      },
      hover: {
        onHover: function(e) {
           var point = this.getElementAtEvent(e);
           if (point.length) e.target.style.cursor = 'pointer';
           else e.target.style.cursor = 'default';
        }
      },
      tooltips: {
        callbacks: {
          label: function(tooltipItem, data) {
            return tooltipItem.value + data.units;
          }
        }
      },
      elements: {
        point: {
          radius: customRadius
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
          const date_clicked = new Date(elements[0]._chart.data.originalLabels[elements[0]._index])
          const note_id = elements[0]._chart.data.datasets[0].note_ids[elements[0]._index]

          debouncedGetNote(date_clicked, note_id)
        }
      }
    }
  });
}

function getNote(date, note_id) {
  if (note_id) {
    Rails.ajax({
      url: '/notes/' + note_id + '/edit',
      type: 'GET'
    });
  } else {
    Rails.ajax({
      url: '/notes/new',
      type: 'GET',
      data: 'note[start_time]=' + date.toISOString()
    });
  }
}

const debouncedGetNote = _.debounce(getNote, 1000, {
  'leading': true
})

function customRadius( context ) {
  const index = context.dataIndex;
  const note_id = context.dataset.note_ids[ index ];
  if (note_id) {
    return 8;
  } else {
    return 0.001;
  }
}

function addNotePoint(date, id) {
  const index = _.findIndex(chart.data.originalLabels, (el) => { return el === date })

  chart.data.datasets.forEach((dataset) => {
    let note_ids = dataset.note_ids

    // If the note already exists, remove it (in case the date has changed).
    const existingIndex = _.findIndex(note_ids, (el) => { return el === id })
    if (existingIndex) {
      note_ids[existingIndex] = null
    }

    // Add the note.
    note_ids[index] = id

    dataset.note_ids = note_ids
  });
  chart.update();
}
