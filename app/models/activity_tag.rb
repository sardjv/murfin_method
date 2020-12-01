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
  validate :validate_tag_matches_type

  def validate_tag_matches_type
    return if tag.nil?

    return if tag.tag_type == tag_type

    errors.add :tag_id, 'the tag must belong to the selected tag_type'
  end
end
