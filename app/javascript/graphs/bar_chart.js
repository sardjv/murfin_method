import Chart from 'chart.js/auto'
import Rails from '@rails/ujs'
import { API } from './api'
import { MissingData } from './missing_data'
import * as SCSSColours from '!!sass-variable-loader!../stylesheets/variables/colours.scss'

window.addEventListener('turbo:load', () => {
  const barChartId = 'bar-chart'
  const context = document.getElementById(barChartId)

  if (context) {
    drawBarChart(context, chartData.bar_chart.data)
  }
})

function drawBarChart(context, data) {
  const colours = data.map(function(e) {
    const val = e.value

    if (val == null) {
      return SCSSColours['unknown']
    } else if (val >= 120) {
      // Over.
      return SCSSColours['over']
    } else if (val >= 80) {
      // About right.
      return SCSSColours['aboutRight']
    } else if (val >= 50) {
      // Under.
      return SCSSColours['under']
    } else {
      // Really Under.
      return SCSSColours['reallyUnder']
    }
  })

  const labels = data.map(function(e) {
    if (e.value) {
      return e.name
    } else {
      return e.name + ' ?'
    }
  })

  const toolTips = data.map(function(e) {
    if (e.value) {
      return e.value + '%'
    } else {
      return 'No data'
    }
  })

  const fallback = MissingData.generate(data)

  const values = data.map(function(e) {
    return e.value || fallback
  })

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
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          callbacks: {
            label: (context) => {
              return toolTips[context.dataIndex]
            }
          }
        }
      },
      scales: {
        x: {
          grid: {
            display: false
          }
        },
        y: {
          grid: {
            borderDash: [7, 7],
            drawBorder: false
          },
          ticks: {
            stepSize: 10,
            callback: function(value) {
              return `${value}%`
            }
          }
        }
      }
    }
  })
}
