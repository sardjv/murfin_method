module TrackableCustomization
  extend ActiveSupport::Concern

  included do
    alias_method :update_tracked_fields_customized, :update_tracked_fields
  end

  def update_tracked_fields_customized(request)
    update_tracked_fields(request)

    old_current = current_sign_in_auth_method
    new_current = request.session[:auth_method]
    self.last_sign_in_auth_method = old_current || new_current
    self.current_sign_in_auth_method = new_current
  end
end
