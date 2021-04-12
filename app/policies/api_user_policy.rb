class ApiUserPolicy < AdminCrudPolicy
  def generate_token?
    user.admin?
  end
end
