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
      tags: %w[circle ellipse path rect svg],
      attributes: %w[class cx cy d fill fill-rule height r rx ry viewbox width x xmlns y]
    )
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'alert' then 'alert alert-danger'
    end
  end
end
