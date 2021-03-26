class TimeRangePolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end
end
