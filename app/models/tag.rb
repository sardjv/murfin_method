# == Schema Information
#
# Table name: tags
#
#  id                 :bigint           not null, primary key
#  name               :string(255)      not null
#  tag_type_id        :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_id          :bigint
#  default_for_filter :boolean          default(FALSE), not null
#
class Tag < ApplicationRecord
  belongs_to :tag_type
  belongs_to :parent, class_name: 'Tag', optional: true
  has_many :children, class_name: 'Tag', inverse_of: :parent, foreign_key: :parent_id, dependent: :nullify

  has_many :tag_associations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id, case_sensitive: false }
  validate :validate_type_hierarchy

  scope :with_tag_type_active_for, ->(klass) { where(tag_type_id: TagType.active_for(klass).select(:id)) }

  def name_with_ancestors
    return "#{parent.name_with_ancestors} > #{name}" if parent

    name
  end

  private

  def validate_type_hierarchy
    return if parent.nil? && tag_type.nil?

    return if parent&.tag_type == tag_type&.parent

    errors.add :parent_id, I18n.t('errors.tag.should_match_parent')
  end
end
