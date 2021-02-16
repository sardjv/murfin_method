import Chart from 'chart.js'
import Rails from '@rails/ujs'
import { API } from './api'
import * as SCSSColours from '!!sass-variable-loader!../stylesheets/variables/colours.scss';
import { Note } from './note'
import minutesHumanized from '../shared/minutes_humanized'

window.addEventListener('turbolinks:load', () => {
  const graphKindSelector = "input:radio[name='graph_kind']"
  let graphKind = 'percentage_delivered'
  const graphContext = $('#line-graph')

  if(graphContext) {
    let prev_graph_kind_val = $(`${graphKindSelector}:checked`).val()
    $(graphKindSelector).on('click', (e) => {
      if(prev_graph_kind_val != e.target.value) {
        graphKind = e.target.value
        drawGraph(graphKind)
        prev_graph_kind_val = graphKind
      }
    })

    $('select.filter').on('change', () => { drawGraph(graphKind) })

    //const userId = graphContext.data('user-id')
    drawGraph(graphKind)
  }
});

function drawGraph(graph_kind) {
  const startYear = parseInt($('#line_graph_filter_start_time_1i').val());
  const startMonth = parseInt($('#line_graph_filter_start_time_2i').val());
  const endYear = parseInt($('#line_graph_filter_end_time_1i').val());
  const endMonth = parseInt($('#line_graph_filter_end_time_2i').val());
  const tagIds = $('#line_graph_tags').val()
  const context = document.getElementById('line-graph');

  if (context) {
    Rails.ajax({
      url: API.url(),
      type: 'GET',
      data: new URLSearchParams({
        'filter_start_month': startMonth,
        'filter_start_year': startYear,
        'filter_end_month': endMonth,
        'filter_end_year': endYear,
        'filter_tag_ids': tagIds,
        'graph_kind': graph_kind
      }).toString(),
      dataType: 'json',
      success: function(data) {
        if (global.chart) { global.chart.destroy() };
        global.chart = line_graph(context, data.line_graph, { graph_kind: graph_kind });

        if(data.average_weekly_percentage_delivered_per_month !== undefined) {
          $('#team-dash-average-delivery').html(`${data.average_weekly_percentage_delivered_per_month}%`)
        }

        if(data.members_under_delivered_percent !== undefined) {
          $('#team-dash-members-under-delivered-percent').html(data.members_under_delivered_percent)
        }
      }
    });
  }
}

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

function buildDatasets(datas, options = {}) {
  let index = 0;
  return datas.map(function(data) {
    const dataset = {
      label: options.dataset_labels ? options.dataset_labels[index] : null,
      data: data.map(function(e) {
        return e.value;
      }),
      notes: data.map(function(e) {
        return JSON.parse(e.notes);
      }),
      fill: false,
      backgroundColor: getColour(index),
      borderColor: getColour(index),
      borderWidth: 5,
      lineTension: 0.3,
      borderCapStyle: 'round',
      pointRadius: 0,
      pointHitRadius: 20,
    }
    index += 1;
    return dataset;
  });
}

function line_graph(context, line_graph, options = {}) {
  const originalLabels = line_graph.data[0].map(function(e) {
    return e.name;
  });

  const formattedLabels = line_graph.data[0].map(function(e) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][new Date(Date.parse(e.name)).getMonth()];
  });

  const units = line_graph.units || ''
  const datasets = buildDatasets(line_graph.data, { dataset_labels: line_graph.dataset_labels })

  const notes = datasets.map(function(dataset) {
    return dataset.notes
  });

  const formatChartValue = (val, units) => {
    return units == 'minutes' ? minutesHumanized(val) : `${val}${units}`
  }

  return new Chart(context, {
    type: 'line',
    data: {
      labels: formattedLabels,
      originalLabels: originalLabels,
      datasets: datasets,
      units: units,
      notes: notes
    },
    options: {
      legend: {
        display: line_graph.dataset_labels ? true : false,
        onHover: function(e) {
          e.target.style.cursor = 'pointer';
        }
      },
      hover: {
        onHover: function(e) {
           let point = this.getElementAtEvent(e);
           if (point.length) e.target.style.cursor = 'pointer';
           else e.target.style.cursor = 'default';
        }
      },
      tooltips: {
        displayColors: false,
        xPadding: 12,
        yPadding: 12,
        callbacks: {
          label: (tooltipItem, data) => {
            let tooltip = []

            const tooltip_str = formatChartValue(tooltipItem.value, data.units)
            tooltip.push(tooltip_str)
            const notes = global.chart.data.datasets[tooltipItem.datasetIndex].notes[tooltipItem.index]
            _.each(Note.toMultilineArray(notes, 50), (note) => {
              tooltip.push(note)
            });

            return tooltip;
          }
        }
      },
      elements: {
        point: {
          pointStyle: (context) => {
            const notes = context.dataset.notes[ context.dataIndex ];
            if (notes.length > 0) {
              return Note.icon(notes[0].state);
            } else {
              return null;
            }
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
            stepSize: units == 'minutes' ? 120 : 10,
            callback: function(value) {
              return formatChartValue(value, units)
            }
          }
        }]
      },
      onClick: (_event, elements) => {
        if(elements[0]) {
          const notes = global.chart.data.datasets[0].notes[elements[0]._index]
          if (notes.length > 0) {
            Note.debouncedGetEditNote(notes[0].id)
          } else {
            const date_clicked = new Date(global.chart.data.originalLabels[elements[0]._index])
            Note.debouncedGetNewNote(date_clicked)
          }
        }
      }
    }
  });
}
