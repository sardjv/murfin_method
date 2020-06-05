FactoryBot.define do
  factory :user do
    id { Faker::Number.unique.number }
    first_name { Faker::Name.unique.first_name }
    last_name  { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
  end
end
