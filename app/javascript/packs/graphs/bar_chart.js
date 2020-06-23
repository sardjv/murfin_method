import * as d3 from 'd3'

window.addEventListener('turbolinks:load', () => {
  // From https://bl.ocks.org/d3noob/8952219
  // MIT License

  // set the dimensions and margins of the graph
  var margin = {top: 20, right: 20, bottom: 30, left: 40},
      width = 960 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

  // set the ranges
  var x = d3.scaleBand()
            .range([0, width])
            .padding(0.1);
  var y = d3.scaleLinear()
            .range([height, 0]);

  // append the svg object to the body of the page
  // append a 'group' element to 'svg'
  // moves the 'group' element to the top left margin
  var svg = d3.select("#bar-chart").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");

  // get the data
  // d3.csv("value.csv").then(function(data) {
  var data = [
    { "name": "Skylar Assaqd", "value": "88" },
    { "name": "Angel George", "value": "87" },
    { "name": "Gretchen Botosh", "value": "82" },
    { "name": "Marcus Bator", "value": "79" },
    { "name": "Brandon Vetrovs", "value": "72"},
    { "name": "Philip Philips", "value": "68" },
    { "name": "Jordyn Korsgaard", "value": "64" },
    { "name": "Mira Korsgaard", "value": "60" },
    { "name": "Ann Herwitz", "value": "53" },
    { "name": "Jaylon Dokidis", "value": "53" },
    { "name": "Chance Torff", "value": "53" },
  ]

  // format the data
  data.forEach(function(d) {
    d.value = +d.value;
  });

  // Scale the range of the data in the domains
  x.domain(data.map(function(d) { return d.name; }));
  y.domain([0, d3.max(data, function(d) { return d.value; })]);

  // append the rectangles for the bar chart
  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.name); })
      .attr("width", x.bandwidth())
      .attr("y", function(d) { return y(d.value); })
      .attr("height", function(d) { return height - y(d.value); });

  // add the x Axis
  svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

  // add the y Axis
  svg.append("g")
      .call(d3.axisLeft(y));

  // text label for the y axis
  svg.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left)
    .attr("x",0 - (height / 2))
    .attr("dy", "1em")
    .style("text-anchor", "middle")
});
