import { selectAll } from 'd3'

window.addEventListener('turbolinks:load', () => {
  selectAll('#d3-test')
    .append('p')
    .text('D3 is working!')
})
