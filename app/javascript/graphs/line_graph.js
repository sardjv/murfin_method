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
        return e.note_ids;
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
          const note_ids = elements[0]._chart.data.datasets[0].note_ids[elements[0]._index]

          debouncedGetNote(date_clicked, note_ids[0])
        }
      }
    }
  });
}

function getNote(date, note_id) {
  const id = note_id
  if (id) {
    Rails.ajax({
      url: '/notes/' + id + '/edit',
      type: 'GET',
      success: function(data, response, request) {
        $('#prev_note').attr('href', getPrevNoteUrl(id))
        $('#next_note').attr('href', getNextNoteUrl(id))
      }
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

function getPrevNoteUrl(note_id) {
  let prev
  global.chart.data.datasets.forEach((dataset) => {
    const ids = _.flatten(dataset.note_ids)
    const index = _.findIndex(ids, (el) => { return el === note_id })
    if (index) {
      let prev_index = index - 1
      if (prev_index < 0) {
        prev_index = ids.length - 1
      }
      prev = ids[prev_index]
    }
  });
  return '/notes/' + prev + '/edit'
}

function getNextNoteUrl(note_id) {
  let next
  global.chart.data.datasets.forEach((dataset) => {
    const ids = _.flatten(dataset.note_ids)
    const index = _.findIndex(ids, (el) => { return el === note_id })
    if (index) {
      let next_index = index + 1
      if (next_index >= ids.length) {
        next_index = 0
      }
      next = ids[next_index]
    }
  });
  return '/notes/' + next + '/edit'
}

function customRadius( context ) {
  const index = context.dataIndex;
  const note_ids = context.dataset.note_ids[ index ];
  if (note_ids.length > 0) {
    return 8;
  } else {
    return 0.001;
  }
}

function addNotePoint(date, id) {
  const index = nearestLabel(chart.data.originalLabels, date)

  chart.data.datasets.forEach((dataset) => {
    // An array of arrays of note_ids like [[], [], [1,2], []].
    let note_ids = dataset.note_ids

    // If the note already exists, remove it (in case the date has changed).
    const existingIndex = _.findIndex(note_ids, (ids) => { return _.includes(ids, id) })
    if (existingIndex != -1) {
      note_ids[existingIndex].pop(id)
    }

    // Add the new note.
    note_ids[index].push(id)

    dataset.note_ids = note_ids
  });
  chart.update();
}

function nearestLabel(labels, date) {
  // Assume labels are sorted chronologically.
  let index = 0
  let nextLabel = labels[index + 1]
  while (index <= labels.length && date >= nextLabel) {
    index++
    nextLabel = labels[index + 1]
  }
  return index
}
