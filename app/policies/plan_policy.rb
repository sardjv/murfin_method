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

  def edit?
    update? || record.signoffs.find_by(user_id: user.id).present?
  end

  def destroy?
    (record.user_id == user.id) || user.admin?
  end

  def change_user?
    record.new_record? && user.admin?
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
        scope.left_joins(:signoffs)
             .where('plans.user_id = :id OR signoffs.user_id = :id', id: user.id)
      end
    end
  end
end
