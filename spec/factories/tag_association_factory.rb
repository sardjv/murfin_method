# == Schema Information
#
# Table name: tag_associations
#
#  id          :bigint           not null, primary key
#  tag_id      :bigint
#  activity_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_type_id :bigint           not null
#
FactoryBot.define do
  factory :tag_association do
    tag_type_id { TagType.all.sample.try(:id) || create(:tag_type).id }
    tag_id { Tag.all.sample.try(:id) || create(:tag).id }
    activity_id { Activity.all.sample.try(:id) || create(:activity).id }
  end
end
