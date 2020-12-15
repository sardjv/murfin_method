module PunditHelper
  private

  def user_not_authorized
    render json: {}, status: :forbidden
  end
end
