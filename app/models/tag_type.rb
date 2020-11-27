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
end
