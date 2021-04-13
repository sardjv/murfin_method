DashboardPolicy = Struct.new(:user, :dashboard) do
  def admin_dashboard?
    user.admin?
  end
end
