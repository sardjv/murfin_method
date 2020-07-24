# == Schema Information
#
# Table name: user_groups
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user_group do
    name { Faker::Commerce.department }
  end
end
