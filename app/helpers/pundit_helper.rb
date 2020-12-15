module PunditHelper
  private

  def user_not_authorized
    if request.xhr?
      render json: {}, status: :forbidden
    else
      redirect_to root_path, alert: notice('forbidden')
    end
  end
end
