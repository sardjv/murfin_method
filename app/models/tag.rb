# == Schema Information
#
# Table name: tags
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  taggable_type :string(255)
#  taggable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Tag < ApplicationRecord
  belongs_to :tag_type

  has_many :activity_tags, dependent: :destroy

  validates :name, :tag_type_id, presence: true
  validates :name, uniqueness: { scope: :tag_type_id, case_sensitive: false }
end
