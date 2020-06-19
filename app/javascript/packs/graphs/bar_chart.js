import { selectAll } from 'd3'

window.addEventListener('turbolinks:load', () => {
  selectAll('#bar-chart')
    .append('p')
    .text('D3 is working!')
})
