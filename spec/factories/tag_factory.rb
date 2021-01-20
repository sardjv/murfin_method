# == Schema Information
#
# Table name: tags
#
#  id                 :bigint           not null, primary key
#  name               :string(255)      not null
#  tag_type_id        :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_id          :bigint
#  default_for_filter :boolean          default(FALSE), not null
#
FactoryBot.define do
  factory :tag do
    name { Faker::Company.unique.industry }
    tag_type_id { TagType.all.sample.try(:id) || create(:tag_type).id }
  end
end
