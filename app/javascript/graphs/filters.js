window.addEventListener('turbolinks:load', () => {
  if (document.getElementById('line-graph')) {
    document.getElementById('line_graph_filter_start_time_1i').addEventListener('change', (event) => {
      console.log('changed start')
    });
    document.getElementById('line_graph_filter_start_time_2i').addEventListener('change', (event) => {
      console.log('changed start')
    });
    document.getElementById('line_graph_filter_end_time_1i').addEventListener('change', (event) => {
      console.log('changed end')
    });
    document.getElementById('line_graph_filter_end_time_2i').addEventListener('change', (event) => {
      console.log('changed end')
    });
  }
});

export class Filters {
}
