# frozen_string_literal: true

module AuthHelper
  def auth_method?(method_name)
    ENV['AUTH_METHOD'] == method_name.to_s
  end
end
