module PunditHelper
  private

  def user_not_authorized
    redirect_to root_path, alert: notice('forbidden')
  end
end
