class HomepagePresenter
  def initialize(args)
    @params = args[:params]
  end

  def bar_chart
    {
      data: [
        { 'name': 'Skylar Assaqd', 'value': '88' },
        { 'name': 'Gretchen Botosh', 'value': '82' },
        { 'name': 'Marcus Bator', 'value': '79' },
        { 'name': 'Brandon Vetrovs', 'value': '72' },
        { 'name': 'Jordyn Korsgaard', 'value': '64' },
        { 'name': 'Mira Korsgaard', 'value': '60' },
        { 'name': 'Ann Herwitz', 'value': '53' },
        { 'name': 'Chance Torff', 'value': '53' }
      ]
    }
  end

  def line_graph
    {
      data: [
        [
          { 'name': 'May', 'value': '50' },
          { 'name': 'June', 'value': '60' },
          { 'name': 'July', 'value': '70' },
          { 'name': 'August', 'value': '80' },
          { 'name': 'September', 'value': '80' },
          { 'name': 'October', 'value': '120' }
        ]
      ]
    }
  end

  def to_json(*_args)
    {
      bar_chart: bar_chart,
      line_graph: line_graph
    }.to_json
  end
end
