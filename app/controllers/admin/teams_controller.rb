class Admin::TeamsController < TeamsController
  before_action :set_context_in_presenter, only: %i[dashboard individuals] # rubocop:disable Rails/LexicallyScopedActionFilter

  def index
    @user_groups = UserGroup.teams.order(:name).page(params[:page])
  end

  private

  def set_context_in_presenter
    @presenter.context = :admin_teams
  end
end
