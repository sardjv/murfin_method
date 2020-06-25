module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def meta_description(page_meta_description)
    content_for(:meta_description) { page_meta_description }
  end

  def heading(page_heading)
    content_for(:heading) { page_heading }
  end

  def current_user_name
    return unless session[:userinfo]

    session[:userinfo].dig('extra', 'raw_info', 'name')
  end

  # From https://github.com/twbs/icons/issues/79
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] += ' ' + options[:class]
    end
    svg['width'] = '2em'
    svg['height'] = '2em'
    puts svg
    doc.to_html.html_safe
  end
end
