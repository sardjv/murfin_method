class AccountController < ApplicationController
  skip_after_action :verify_authorized
  def show
    @user_memberships = current_user.memberships.includes(user_group: :group_type).group_by { |m| m.user_group.group_type }
  end
end
