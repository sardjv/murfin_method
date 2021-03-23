import Chart from 'chart.js'
import Rails from '@rails/ujs'
import { API } from './api'
import * as SCSSColours from '!!sass-variable-loader!../stylesheets/variables/colours.scss';
import { Note } from './note'
import minutesHumanized from '../shared/minutes_humanized'
import { format, addDays } from 'date-fns'
import { pickBy } from 'lodash'

window.addEventListener('turbolinks:load', () => {
  const lineGraphId = 'line-graph'
  const context = document.getElementById(lineGraphId)

  if (context) {
    const graphKindSelector = "input:radio[name='graph_kind']"
    const graphTimeScopeSelector = "input:radio[name='time_scope']"

    let prev_graph_kind = $(`${graphKindSelector}:checked`).val()
    let prev_time_scope = $(`${graphTimeScopeSelector}:checked`).val()

    let current_graph_kind = prev_graph_kind
    let current_time_scope = prev_time_scope

    $(graphKindSelector).on('click', (e) => {
      if(prev_graph_kind != e.target.value) {
        current_graph_kind = e.target.value
        drawGraph(context, current_graph_kind, current_time_scope)
        prev_graph_kind = current_graph_kind
      }
    })

    $(graphTimeScopeSelector).on('click', (e) => {
      if(prev_time_scope != e.target.value) {
        current_time_scope = e.target.value
        drawGraph(context, current_graph_kind, current_time_scope)
        prev_time_scope = current_time_scope
      }
    })

    drawGraph(context, current_graph_kind, current_time_scope)
  }
});

function drawGraph(context, graph_kind, time_scope) {
  const query_params = prepareQueryParamsFromFilters()
  const url_params = { query: query_params, graph_kind: graph_kind, time_scope: time_scope }

  Rails.ajax({
    url: API.url(),
    type: 'GET',
    data: $.param(url_params).toString(),
    dataType: 'json',
    success: function(data) {
      if (global.chart) { global.chart.destroy() }
      global.chart = line_graph(context, data.line_graph, { graph_kind: graph_kind, time_scope: time_scope })

      if(data.average_delivery_percent !== undefined) {
        $('#team-dash-average-delivery-percent').html(`${data.average_delivery_percent}%`)
      }

      if(data.members_under_delivered_percent !== undefined) {
        $('#team-dash-members-under-delivered-percent').html(data.members_under_delivered_percent)
      }
    }
  });
}

function prepareQueryParamsFromFilters() {
  const filtersFormSelector = 'form#filters-form'

  let params = {}

  if($(`${filtersFormSelector} #query_filter_start_date`).length > 0) {
    params = {
      filter_start_date: $(`${filtersFormSelector} #query_filter_start_date`).val(),
      filter_end_date: $(`${filtersFormSelector} #query_filter_end_date`).val()
    }
  }

  params.filter_tag_ids = $(`${filtersFormSelector} #query_filter_tag_ids`).val()

  params = pickBy(params, v => v !== undefined ) // use loadash' pickBy remove keys where value is undefined
  return params
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
  })

  const formattedLabels = line_graph.data[0].map(function(e) {
    let date = new Date(Date.parse(e.name))

    if(options.time_scope == 'weekly') {
      let date_eof_week = addDays(date, 7)

      let label = format(date, 'MMM d') + ' - '
      if(date.getMonth() == date_eof_week.getMonth()) {
        label += format(date_eof_week, 'd')
      } else {
        label += format(date_eof_week, 'MMM d')
      }
      return label
    } else if (options.time_scope == 'monthly') {
      return format(date, 'MMM yyyy')
    }
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
