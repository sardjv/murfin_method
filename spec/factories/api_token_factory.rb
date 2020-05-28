FactoryBot.define do
  factory :api_token do
    name { Faker::Alphanumeric.alpha(number: 3).upcase }
  end
end
