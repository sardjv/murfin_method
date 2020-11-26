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
class TagType < ApplicationRecord
  has_many :tags, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
