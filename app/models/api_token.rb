class ApiToken < ApplicationRecord
  has_secure_token :content
end
