class PlanPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    (record.user_id == user.id) || user.admin?
  end

  def update?
    (record.user_id == user.id) || user.admin?
  end

  def destroy?
    (record.user_id == user.id) || user.admin?
  end
end
