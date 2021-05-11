module PdfHelper
  def pdf_stylesheet_pack_tag(source)
    options = { media: 'all', 'data-turbo-track': 'reload' }

    options[:host] = "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}" if pdf_user_full_url?

    stylesheet_pack_tag(source, **options)
  end

  def pdf_javascript_pack_tag(source)
    options = { 'data-turbo-track': 'reload' }

    options[:host] = "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}" if pdf_user_full_url?

    javascript_pack_tag(source, **options)
  end

  def pdf_image_url(source, _options = {})
    if pdf_user_full_url?
      asset_pack_path(source, host: "#{Webpacker.dev_server.host}:#{Webpacker.dev_server.port}")
    else
      asset_pack_path(source)
    end
  end

  private

  def pdf_user_full_url?
    Rails.env.development? && pdf? && !params[:layout]
  end
end
