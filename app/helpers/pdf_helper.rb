module PdfHelper
  def pdf_stylesheet_pack_tag(source)
    options = { media: 'all', 'data-turbolinks-track': 'reload' }

    if Rails.env.development? && pdf? && !params[:layout]
      wds = Webpacker.dev_server
      options[:host] = "#{wds.host}:#{wds.port}"
    end

    stylesheet_pack_tag(source, **options)
  end

  def pdf_javascript_pack_tag(source)
    options = { 'data-turbolinks-track': 'reload' }

    if Rails.env.development? && pdf? && !params[:layout]
      wds = Webpacker.dev_server
      options[:host] = "#{wds.host}:#{wds.port}"
    end

    javascript_pack_tag(source, **options)
  end
end
