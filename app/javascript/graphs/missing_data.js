export class MissingData {
  // Generate a 'mid-point' value for bars representing missing data.
  // Based on min and max data so it shows up on the graph.
  static generate(data) {
    const min = this.getMinimum(data)
    const max = this.getMaximum(data)
    return ((max - min) * 0.25) + min
  }

  static getMinimum(data) {
    let min = null;
    data.forEach(function(e) {
      if (e.value != null && (min == null || e.value < min)) {
        min = e.value;
      }
    });
    return min;
  }

  static getMaximum(data) {
    let max = null;
    data.forEach(function(e) {
      if (e.value != null && (max == null || e.value > max)) {
        max = e.value;
      }
    });
    return max;
  }
}
