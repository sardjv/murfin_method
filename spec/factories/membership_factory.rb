# == Schema Information
#
# Table name: memberships
#
#  id            :bigint           not null, primary key
#  role          :string(255)      default("member"), not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :membership do
    user_group_id { UserGroup.all.sample.try(:id) || create(:user_group).id }
    user_id { User.all.sample.try(:id) || create(:user).id }
  end
end
