# == Schema Information
#
# Table name: tags
#
#  id          :bigint           not null, primary key
#  name        :string(255)      not null
#  tag_type_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Tag < ApplicationRecord
  belongs_to :tag_type

  has_many :activity_tags, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :tag_type_id, case_sensitive: false }
end
