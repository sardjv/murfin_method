class SignoffPolicy < ApplicationPolicy
  def sign?
    (record.user_id == user.id) || user.admin?
  end

  def revoke?
    sign?
  end
end
