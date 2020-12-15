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

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
