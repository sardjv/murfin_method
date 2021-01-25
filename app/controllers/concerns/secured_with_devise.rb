module SecuredWithDevise
  extend ActiveSupport::Concern

  def user_authenticated?
    user_signed_in?
  end
end
