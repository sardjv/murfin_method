class DashboardPresenter
  def initialize(args)
    @params = args[:params]
  end

  def paginated_users
    User.page(@params[:page])
  end
end
