# == Schema Information
#
# Table name: memberships
#
#  id            :bigint           not null, primary key
#  role          :string(255)      default("member"), not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Membership < ApplicationRecord
  ROLES = %w[member lead].freeze

  belongs_to :user_group
  belongs_to :user

  validates :role, inclusion: { in: ROLES }, allow_blank: false
  validates :user_group, presence: true, uniqueness: { scope: :user }
  validates :user, presence: true
end
