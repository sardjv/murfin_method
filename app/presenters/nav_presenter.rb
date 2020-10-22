class NavPresenter
  def initialize(args)
    @params = args[:params]
    @current_user = args[:current_user]
  end

  def navs
    return [] unless @current_user

    [
      {
        label: I18n.t('nav.dashboard'),
        path: %i[dashboard],
        enabled: true
      },
      {
        label: I18n.t('nav.team_dashboard'),
        path: [:dashboard, :team, { id: first_team }],
        subnavs: teams.map { |team| team_subnav(team) },
        enabled: @current_user&.lead?
      },
      {
        label: I18n.t('nav.admin_dashboard'),
        path: %i[admin dashboard],
        subnavs: [
          { label: I18n.t('nav.tabs.admin_dashboard'),
            path: %i[admin dashboard],
            controllers: ['admin/dashboard'] },
          { label: I18n.t('nav.tabs.admin_users'),
            path: %i[admin users],
            controllers: ['admin/users'] },
          { label: I18n.t('nav.tabs.admin_group_types'),
            path: %i[admin group_types],
            controllers: ['admin/group_types', 'admin/user_groups'] },
          { label: I18n.t('nav.tabs.time_ranges'),
            path: %i[admin time_ranges],
            controllers: ['admin/time_ranges'] }
        ],
        enabled: @current_user&.admin?
      }
    ]
  end

  def team_subnav(team)
    {
      label: team.name,
      path: [:dashboard, :team, { id: team }],
      controllers: ['teams'],
      actions: %w[dashboard individuals]
    }
  end

  def any_subnavs_active?(nav)
    nav[:subnavs]&.any? { |subnav| subnav_active?(subnav) }
  end

  def subnav_active?(subnav)
    subnav[:controllers].include?(@params[:controller]) && active_action?(subnav)
  end

  def active_action?(subnav)
    return true unless subnav[:actions]

    subnav[:actions].include?(@params[:action])
  end

  def first_team
    teams.first
  end

  def teams
    return [] unless @current_user

    @current_user.user_groups.merge(Membership.lead)
  end
end
