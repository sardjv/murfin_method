# == Schema Information
#
# Table name: memberships
#
#  id            :bigint           not null, primary key
#  role          :integer          default("member"), not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Membership < ApplicationRecord
  enum role: { member: 0, lead: 1 }

  belongs_to :user_group
  belongs_to :user

  validates :user_group, presence: true, uniqueness: { scope: :user }
  validates :user, :role, presence: true
end
