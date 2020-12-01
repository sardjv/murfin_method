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
class ActivityTag < ApplicationRecord
  belongs_to :tag_type
  belongs_to :tag, optional: true
  belongs_to :activity

  validates :activity_id, uniqueness: { scope: %i[tag_type_id tag_id] }
end
