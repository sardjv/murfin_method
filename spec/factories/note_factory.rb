FactoryBot.define do
  factory :note do
    content { Faker::Lorem.sentences }
  end
end
