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
    update? ||
      record.signoffs.find_by(user_id: user.id).present? ||
      Membership.exists?(user_group_id: record.user.user_group_ids, role: 'lead', user_id: user.id)
  end

  def destroy?
    (record.user_id == user.id) || user.admin?
  end

  def download?
    edit?
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
      scope.left_joins(:signoffs)
           .where('plans.user_id = :id OR signoffs.user_id = :id', id: user.id)
    end
  end
end
