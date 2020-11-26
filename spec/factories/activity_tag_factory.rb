# == Schema Information
#
# Table name: tags
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  taggable_type :string(255)
#  taggable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :activity_tag do
    tag_id { Tag.all.sample.try(:id) || create(:tag).id }
    activity_id { Activity.all.sample.try(:id) || create(:activity).id }
  end
end
