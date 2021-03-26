class ApiUserPolicy < ApplicationPolicy
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

  def show?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def generate_token?
    user.admin?
  end
end
