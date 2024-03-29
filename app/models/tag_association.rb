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
class TagAssociation < ApplicationRecord
  belongs_to :tag_type
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :taggable_id, uniqueness: { scope: %i[taggable_type tag_type_id tag_id], case_sensitive: false }
  validate :validate_tag_matches_type
  validate :validate_tag_parent
  validate :validate_tag_child
  validate :validate_tag_type_active_for_taggables

  before_validation do
    self.tag_type_id ||= tag.tag_type_id if tag
  end

  private

  def validate_tag_matches_type
    return unless tag
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

  def validate_tag_type_active_for_taggables
    return unless taggable && tag_type

    assoc_name = taggable.class.table_name
    return if tag_type.send("active_for_#{assoc_name}_at").present?

    errors.add :tag_type_id, I18n.t('errors.tag_type.should_be_active_for_taggable', taggable_name: assoc_name.humanize.pluralize.downcase)
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
    taggable&.tag_associations&.find { |ta| ta.tag_type == tag_type&.parent }&.tag
  end

  def child_tag
    taggable&.tag_associations&.find { |at| at.tag_type&.parent == tag_type }&.tag
  end
end
