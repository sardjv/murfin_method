class UserGroupPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  # team

  def dashboard?
    user.admin? || user_group_lead?
  end

  def individuals?
    user.admin? || user_group_lead?
  end

  def plans?
    user.admin? || user_group_lead?
  end

  # team individual

  def show?
    user.admin? || user_group_lead?
  end

  def data?
    user.admin? || user_group_lead?
  end

  private

  def user_group_lead?
    Membership.exists?(user_group_id: record.id, role: 'lead', user_id: user.id)
  end
end
