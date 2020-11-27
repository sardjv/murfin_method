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
  belongs_to :tag
  belongs_to :activity

  validates :activity_id, uniqueness: { scope: :tag_id }
end
