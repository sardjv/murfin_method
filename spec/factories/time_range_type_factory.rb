# == Schema Information
#
# Table name: time_range_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :time_range_type do
    name { Faker::TimeRangeType.unique.name }
  end
end
