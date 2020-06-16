import { selectAll } from 'd3'

window.addEventListener('DOMContentLoaded', () => {
  selectAll('#d3-test')
    .append('p')
    .text('D3 is working!')
})
