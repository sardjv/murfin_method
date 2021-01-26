module SecuredWithDevise
  extend ActiveSupport::Concern

  included do
    alias_method :authenticate_user_via_devise!, :authenticate_user!
  end

  #protected

  def user_authenticated_via_devise?
    puts 'user_authenticated_via_devise?'
    user_signed_in?
  end
end
