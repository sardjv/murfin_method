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
        path: %i[user dashboard],
        enabled: true
      },
      {
        label: I18n.t('nav.team_dashboard'),
        path: %i[teams dashboard],
        subnavs: [
          { label: I18n.t('nav.tabs.team'),
            path: %i[teams dashboard],
            controllers: ['dashboard'],
            actions: ['teams'] },
          { label: I18n.t('nav.tabs.individuals'),
            path: %i[individuals dashboard],
            controllers: ['dashboard'],
            actions: ['individuals'] }
        ],
        enabled: @current_user&.lead?
      },
      {
        label: I18n.t('nav.admin_dashboard'),
        path: %i[admin dashboard],
        subnavs: [
          { label: I18n.t('nav.tabs.admin_dashboard'),
            path: %i[admin dashboard],
            controllers: ['dashboard'],
            actions: ['admin'] },
          { label: I18n.t('nav.tabs.admin_users'),
            path: %i[admin users],
            controllers: ['admin/users'],
            actions: %w[index new edit] },
          { label: I18n.t('nav.tabs.admin_group_types'),
            path: %i[admin group_types],
            controllers: ['admin/group_types', 'admin/user_groups'],
            actions: %w[index new edit] },
          { label: I18n.t('nav.tabs.time_ranges'),
            path: %i[admin time_ranges],
            controllers: ['admin/time_ranges'],
            actions: %w[index new edit] }
        ],
        enabled: @current_user&.admin?
      }
    ]
  end

  def subnav_active?(subnav)
    subnav[:controllers].include?(@params[:controller]) &&
      subnav[:actions].include?(@params[:action])
  end
end
