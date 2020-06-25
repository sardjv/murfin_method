class DashboardPresenter
  def initialize(args)
    @params = args[:params]
  end

  def paginated_users
    User.page(@params[:page])
  end

  def bar_chart
    [
      { 'name': 'Skylar Assaqd', 'value': '88' },
      { 'name': 'Angel George', 'value': '87' },
      { 'name': 'Gretchen Botosh', 'value': '82' },
      { 'name': 'Marcus Bator', 'value': '79' },
      { 'name': 'Brandon Vetrovs', 'value': '72' },
      { 'name': 'Philip Philips', 'value': '68' },
      { 'name': 'Jordyn Korsgaard', 'value': '64' },
      { 'name': 'Mira Korsgaard', 'value': '60' },
      { 'name': 'Ann Herwitz', 'value': '53' },
      { 'name': 'Jaylon Dokidis', 'value': '53' },
      { 'name': 'Chance Torff', 'value': '53' }
    ]
  end

  def to_json(*_args)
    {
      bar_chart: bar_chart
    }.to_json
  end
end
