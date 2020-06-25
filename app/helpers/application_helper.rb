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
    svg['class'] += " #{options[:class]}" if options[:class].present?
    svg['width'] = svg['height'] = '2em'
    sanitize(
      doc.to_html,
      tags: %w[svg path],
      attributes: %w[class width height viewbox fill xmlns fill-rule d]
    )
  end
end
