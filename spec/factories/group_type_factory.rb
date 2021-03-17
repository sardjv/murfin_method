# == Schema Information
#
# Table name: group_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :group_type do
    name { Faker::Company.industry }
  end
end
