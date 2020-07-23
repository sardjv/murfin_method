# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)      not null
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end
end
