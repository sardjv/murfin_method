module CapybaraHelpers
  def have_bootstrap_select(*args)
    have_select(args.first, **args.last.merge(visible: false))
  end

  def bootstrap_select(labels, attrs)
    labels = Array.wrap(labels)

    within find('label', text: attrs[:from].to_s).find(:xpath, '..') do
      dropdown_toggle = first('button.dropdown-toggle')

      dropdown_toggle.click

      within 'ul.dropdown-menu.show' do
        labels.each do |label|
          find('.dropdown-menu li', text: label).click
        end
      end

      if page.has_css?('button.dropdown-toggle[aria-expanded=true]')
        dropdown_toggle.click # hide dropdown if still visible, e.g. happens if select is multiple
      end
    end
  end

  def bootstrap_select_year(value, attrs)
    within find('label', text: attrs[:from].to_s).find(:xpath, '..') do
      all('button.dropdown-toggle')[2].click
      find('.dropdown-menu li', text: value).click
    end
  end
end
