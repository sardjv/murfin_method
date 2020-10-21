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
        path: %i[dashboard teams],
        subnavs: [
          { label: I18n.t('nav.tabs.team'),
            path: %i[dashboard teams],
            controllers: ['teams'],
            actions: 'dashboard' },
          { label: I18n.t('nav.tabs.individuals'),
            path: %i[individuals teams],
            controllers: ['teams'],
            actions: 'individuals' }
        ],
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
            controllers: ['admin/group_types', 'admin/user_groups'] }
        ],
        enabled: @current_user&.admin?
      }
    ]
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
end
