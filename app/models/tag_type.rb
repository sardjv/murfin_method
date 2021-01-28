# == Schema Information
#
# Table name: tag_types
#
#  id                        :bigint           not null, primary key
#  name                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  parent_id                 :bigint
#  active_for_activities_at  :datetime
#  active_for_time_ranges_at :datetime
#
class TagType < ApplicationRecord
  include Activatable
  activatable classes: %w[activities time_ranges]

  has_many :tags, dependent: :destroy
  belongs_to :parent, class_name: 'TagType', optional: true
  has_many :children, class_name: 'TagType', inverse_of: :parent, foreign_key: :parent_id, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :parent, presence: true, if: :parent_id
  validate :validate_acyclic, on: :update

  def name_with_ancestors
    return "#{parent.name_with_ancestors} > #{name}" if parent

    name
  end

  private

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
