# == Schema Information
#
# Table name: activity_tags
#
#  id          :bigint           not null, primary key
#  tag_id      :bigint           not null
#  activity_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :activity_tag do
    tag_type_id { TagType.all.sample.try(:id) || create(:tag_type).id }
    tag_id { Tag.all.sample.try(:id) || create(:tag).id }
    activity_id { Activity.all.sample.try(:id) || create(:activity).id }
  end
end
