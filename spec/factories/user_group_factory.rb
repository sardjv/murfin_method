# == Schema Information
#
# Table name: user_groups
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type_id :bigint           not null
#
FactoryBot.define do
  factory :user_group do
    name { Faker::Commerce.unique.department }
    group_type_id { GroupType.all.sample.try(:id) || create(:group_type).id }
  end

  trait :team do
    group_type { GroupType.where(name: 'team').first || FactoryBot.create(:group_type, name: 'team') }
  end

  trait :band do
    group_type { GroupType.where(name: 'band').first || FactoryBot.create(:group_type, name: 'band') }
  end
end
