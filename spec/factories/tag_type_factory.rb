# == Schema Information
#
# Table name: tag_types
#
#  id                        :bigint           not null, primary key
#  name                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  parent_id                 :bigint
#  active_for_activities_at  :datetime
#  active_for_time_ranges_at :datetime
#
FactoryBot.define do
  factory :tag_type do
    name { Faker::Company.industry }
  end
end
