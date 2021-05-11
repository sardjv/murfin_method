class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :current_user
  # identified_by :session_id

  def connect
    # self.current_user = env['warden'].user
    self.current_user = find_verified_user
    # self.session_id = request.session.id
    reject_unauthorized_connection unless current_user # || self.session_id
  end

  protected

  def find_verified_user
    pp "----find ver user--cookies.signed[:user_id]", cookies.signed[:user_id]
    verified_user = User.find_by(id: cookies.signed[:user_id])

    if verified_user # && cookies.signed['user.expires_at'] > Time.now
      verified_user
    else
      reject_unauthorized_connection
    end
  end
end
