# == Schema Information
#
# Table name: tag_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TagType < ApplicationRecord
  has_many :tags, dependent: :destroy
  belongs_to :parent, class_name: 'TagType', optional: true
  has_many :children, class_name: 'TagType', inverse_of: :parent, foreign_key: :parent_id, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_acyclic, on: :update

  def name_with_parent
    return "#{parent.name} > #{name}" if parent

    name
  end

  def validate_acyclic
    next_parent = parent

    while next_parent
      if next_parent.parent_id == id
        errors.add :parent_id, 'cannot be descended from itself'
        break
      else
        next_parent = next_parent.parent
      end
    end
  end
end
