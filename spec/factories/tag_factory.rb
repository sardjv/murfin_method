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
  factory :tag do
    content { Faker::Company.industry }
    taggable_type { 'Activity' }
    taggable_id { Activity.all.sample.try(:id) || create(:activity).id }
  end
end
