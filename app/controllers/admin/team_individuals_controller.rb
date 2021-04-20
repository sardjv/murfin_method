class Admin::TeamIndividualsController < TeamIndividualsController
  before_action :set_context_in_presenter

  private

  def set_context_in_presenter
    @presenter.context = :admin_teams
  end
end
