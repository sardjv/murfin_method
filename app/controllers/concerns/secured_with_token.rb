module SecuredWithToken
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    auth_token
  rescue ActiveRecord::RecordNotFound, JWT::VerificationError, JWT::DecodeError
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  def http_token
    request.headers['Authorization'].split.last if request.headers['Authorization'].present?
  end

  def auth_token
    decoded_token = JWT.decode http_token, ENV['JWT_SECRET'], true, { algorithm: ENV['JWT_ALGORITHM'] }
    api_user_id = decoded_token.first['data']
    api_timestamp = decoded_token.first['timestamp']
    ApiUser.find_by!(id: api_user_id, token_generated_at: api_timestamp)
  end
end
