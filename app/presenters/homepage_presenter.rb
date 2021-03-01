# frozen_string_literal: true

class HomepagePresenter
  def initialize(args)
    @params = args[:params]
  end

  def bar_chart
    { data: [
      { 'name': 'Skylar Assaqd', 'value': '88', 'notes': '[]' },
      { 'name': 'Gretchen Botosh', 'value': '82', 'notes': '[]' },
      { 'name': 'Marcus Bator', 'value': '79', 'notes': '[]' },
      { 'name': 'Brandon Vetrovs', 'value': '72', 'notes': '[]' },
      { 'name': 'Jordyn Korsgaard', 'value': '64', 'notes': '[]' },
      { 'name': 'Mira Korsgaard', 'value': '60', 'notes': '[]' },
      { 'name': 'Ann Herwitz', 'value': '53', 'notes': '[]' },
      { 'name': 'Chance Torff', 'value': '53', 'notes': '[]' }
    ] }
  end

  def line_graph
    { data: [
      [
        { 'name': '2019-05-01T00:00:00.000Z', 'value': '50', 'notes': '[]' },
        { 'name': '2019-06-01T00:00:00.000Z', 'value': '60', 'notes': '[]' },
        { 'name': '2019-07-01T00:00:00.000Z', 'value': '70', 'notes': '[]' },
        { 'name': '2019-08-01T00:00:00.000Z', 'value': '80', 'notes': '[]' },
        { 'name': '2019-09-01T00:00:00.000Z', 'value': '80', 'notes': '[]' },
        { 'name': '2019-10-01T00:00:00.000Z', 'value': '120', 'notes': '[]' }
      ]
    ] }
  end

  def to_json(*_args)
    {
      bar_chart: bar_chart,
      line_graph: line_graph
    }.to_json
  end
end
