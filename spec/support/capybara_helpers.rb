module CapybaraHelpers
  def have_bootstrap_select(*args)
    have_select(args.first, **args.last.merge(visible: false))
  end

  def bootstrap_select(value, attrs)
    within find('label', text: attrs[:from].to_s).find(:xpath, '..') do
      first('button.dropdown-toggle').click
      find('.dropdown-menu li', text: value).click
    end
  end

  def bootstrap_select_year(value, attrs)
    within find('label', text: attrs[:from].to_s).find(:xpath, '..') do
      all('button.dropdown-toggle')[2].click
      find('.dropdown-menu li', text: value).click
    end
  end
end
