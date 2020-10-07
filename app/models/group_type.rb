# == Schema Information
#
# Table name: group_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GroupType < ApplicationRecord
  has_many :user_groups, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
