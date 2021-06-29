module TeamIndividualsHelper

  def team_individual_path_for_context(user_group, user)
    @context == :admin_teams ? admin_team_individual_path(user_group, user) : team_individual_path(user_group, user)
  end

end