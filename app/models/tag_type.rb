# == Schema Information
#
# Table name: tag_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
class TagType < ApplicationRecord
  has_many :tags, dependent: :destroy
  belongs_to :parent, class_name: 'TagType', optional: true
  has_many :children, class_name: 'TagType', inverse_of: :parent, foreign_key: :parent_id, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_acyclic, on: :update

  def active_for_activities=(state)
    assign_attributes(active_for_activities_at: (checked?(state) ? Time.current : nil))
  end

  def active_for_activities
    active_for_activities_at.present?
  end
  alias active_for_activities? active_for_activities

  def active_for_time_ranges=(state)
    assign_attributes(active_for_time_ranges_at: (checked?(state) ? Time.current : nil))
  end

  def active_for_time_ranges
    active_for_time_ranges_at.present?
  end
  alias active_for_time_ranges? active_for_time_ranges

  def name_with_parent
    return "#{parent.name_with_parent} > #{name}" if parent

    name
  end

  private

  def checked?(state)
    %w[1 true].include?(state.to_s)
  end

  def validate_acyclic
    next_parent = parent

    while next_parent
      if next_parent.parent_id == id
        errors.add :parent_id, I18n.t('errors.tag_type.should_be_acyclic')
        break
      else
        next_parent = next_parent.parent
      end
    end
  end
end
