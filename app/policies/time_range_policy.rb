class TimeRangePolicy < ApplicationPolicy
  def update?
    (record.user_id == user.id) || user.admin?
  end
end
