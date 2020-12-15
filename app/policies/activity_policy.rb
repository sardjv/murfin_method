class ActivityPolicy < ApplicationPolicy
  def update?
    (record.plan.user_id == user.id) || user.admin?
  end
end
