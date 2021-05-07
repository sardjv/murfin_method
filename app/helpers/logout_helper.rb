# app/helpers/logout_helper.rb

module LogoutHelper
  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: ENV['AUTH0_CLIENT_ID']
    }

    URI::HTTPS.build(host: ENV['AUTH0_CLIENT_DOMAIN'],
                     path: '/v2/logout',
                     query: to_query(request_params))
  end

  private

  def to_query(hash)
    hash.map do |k, v|
      "#{k}=#{CGI.escape(v)}" unless v.nil?
    end.reject(&:nil?).join('&')
  end
end
