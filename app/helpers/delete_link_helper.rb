module DeleteLinkHelper
  def delete_button_to(title, url, options = {})
    html_options = {
      class: "delete_button_to",
      method: "delete"
    }.merge(options.delete(:html_options) || {})

    form_for :delete, url: url, html: html_options do |f|
      f.submit title, options
    end
  end
end
