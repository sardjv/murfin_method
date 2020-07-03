function data_url() {
  if (window.location.pathname == '/') {
    // Can't call root/.json.
    return '/pages/home.json'
  } else {
    return window.location.pathname + '.json'
  }
}

// Generate a 'mid-point' value for bars representing missing data.
// Based on min and max data so it shows up on the graph.
function missingDataVal(data) {
  var min = getMinimum(data)
  var max = getMaximum(data)
  return ((max - min) * 0.25) + min
}

function getMinimum(data) {
  var min = null;
  data.forEach(function(e) {
    if (e.value != null && (min == null || e.value < min)) {
      min = e.value;
    }
  });
  return min;
}

function getMaximum(data) {
  var max = null;
  data.forEach(function(e) {
    if (e.value != null && (max == null || e.value > max)) {
      max = e.value;
    }
  });
  return max;
}
