# == Schema Information
#
# Table name: user_groups
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type_id :bigint           not null
#
class UserGroup < ApplicationRecord
  belongs_to :group_type
  has_many :memberships, dependent: :destroy
  accepts_nested_attributes_for :memberships
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: { scope: :group_type, case_sensitive: false }

  scope :teams, -> { joins(:group_type).where(group_types: { name: 'Team' }) }
end
