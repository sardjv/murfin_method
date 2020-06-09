# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.unique.first_name }
    last_name  { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
  end
end
