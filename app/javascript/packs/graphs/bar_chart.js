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
  var svg = d3.select("body").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform",
            "translate(" + margin.left + "," + margin.top + ")");

  // get the data
  // d3.csv("sales.csv").then(function(data) {
    var data = [
      { "salesperson": "Bob", "sales": "33"},
      { "salesperson": "Robin", "sales": "12" },
      { "salesperson": "Anne", "sales": "41" },
      { "salesperson": "Mark", "sales": "16" },
      { "salesperson": "Joe", "sales": "59" },
      { "salesperson": "Eve", "sales": "38" },
      { "salesperson": "Karen", "sales": "21" },
      { "salesperson": "Kirsty", "sales": "25" },
      { "salesperson": "Chris", "sales": "30" },
      { "salesperson": "Lisa", "sales": "47" },
      { "salesperson": "Tom", "sales": "5" },
      { "salesperson": "Stacy", "sales": "20" },
      { "salesperson": "Charles", "sales": "13" },
      { "salesperson": "Mary", "sales": "29" },
    ]

    // format the data
    data.forEach(function(d) {
      d.sales = +d.sales;
    });

    // Scale the range of the data in the domains
    x.domain(data.map(function(d) { return d.salesperson; }));
    y.domain([0, d3.max(data, function(d) { return d.sales; })]);

    // append the rectangles for the bar chart
    svg.selectAll(".bar")
        .data(data)
      .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.salesperson); })
        .attr("width", x.bandwidth())
        .attr("y", function(d) { return y(d.sales); })
        .attr("height", function(d) { return height - y(d.sales); });

    // add the x Axis
    svg.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x));

    // add the y Axis
    svg.append("g")
        .call(d3.axisLeft(y));

  // });
});
