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
  validate :validate_tag_hierarchy

  private

  def validate_tag_matches_type
    return if tag.nil?

    return if tag.tag_type == tag_type

    errors.add :tag_id, 'the tag must belong to the selected tag_type'
  end

  def validate_tag_hierarchy
    return if tag.nil? || tag.tag_type.parent.nil?

    return if correct_parent_tag?

    errors.add :tag_id, 'the tag must match the selected parent tag'
  end

  def correct_parent_tag?
    activity.activity_tags.find { |at| at.tag_type == tag_type.parent }.tag == tag.parent
  end
end
