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
  # To view available icons: `ls node_modules/bootstrap-icons/icons/`
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    svg['class'] += " #{options[:class]}" if options[:class].present?
    svg['width'] = svg['height'] = options[:width] || options[:height] || '1em'
    # Note: if something is missing from an icon, you need to add the relevant tags and attributes
    # to the sanitize parameters below so they get through.
    sanitize(
      doc.to_html,
      tags: %w[svg path circle ellipse rect],
      attributes: %w[class width height viewBox fill xmlns fill-rule d x y cx cy r rx ry]
    )
  end
end
