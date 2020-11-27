# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  tag_type_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :bigint
#
FactoryBot.define do
  factory :tag do
    name { Faker::Company.industry }
    tag_type_id { TagType.all.sample.try(:id) || create(:tag_type).id }
  end
end
