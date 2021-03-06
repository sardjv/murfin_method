# == Schema Information
#
# Table name: tag_associations
#
#  id            :bigint           not null, primary key
#  tag_id        :bigint
#  taggable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_type_id   :bigint           not null
#  taggable_type :string(255)      not null
#
FactoryBot.define do
  factory :tag_association do
    tag_type_id { TagType.all.sample.try(:id) || create(:tag_type).id }
    tag_id { Tag.all.sample.try(:id) || create(:tag).id }
    taggable_id { Activity.all.sample.try(:id) || create(:activity).id }
    taggable_type { 'Activity'.freeze }

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
