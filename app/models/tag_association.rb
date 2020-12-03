# == Schema Information
#
# Table name: tag_associations
#
#  id          :bigint           not null, primary key
#  tag_id      :bigint
#  taggable_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_type_id :bigint           not null
#
class TagAssociation < ApplicationRecord
  belongs_to :tag_type
  belongs_to :tag, optional: true
  belongs_to :taggable, polymorphic: true

  validates :taggable_id, uniqueness: { scope: %i[taggable_type tag_type_id tag_id], case_sensitive: false }
  validate :validate_tag_matches_type
  validate :validate_tag_parent
  validate :validate_tag_child

  private

  def validate_tag_matches_type
    return if tag.nil?

    return if tag.tag_type == tag_type

    errors.add :tag_id, I18n.t('errors.tag.should_match_tag_type')
  end

  def validate_tag_parent
    return if correct_parent_tag?

    errors.add :tag_id, I18n.t('errors.tag.should_match_parent')
  end

  def validate_tag_child
    return if correct_child_tag?

    errors.add :tag_id, I18n.t('errors.tag.should_match_parent')
  end

  def correct_parent_tag?
    return true if tag.nil? || tag.tag_type.parent.nil?

    # e.g., if Category is DCC, is this a DCC Subcategory?
    parent_tag == tag.parent
  end

  def correct_child_tag?
    return false if child_tag && tag.nil?

    # e.g., if this is a DCC Category, is the child a DCC Subcategory?
    child_tag.nil? || tag.children.include?(child_tag)
  end

  def parent_tag
    taggable&.tag_associations&.find { |at| at.tag_type == tag_type.parent }&.tag
  end

  def child_tag
    taggable&.tag_associations&.find { |at| at.tag_type.parent == tag_type }&.tag
  end
end
