# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string(255)      not null
#  last_name  :string(255)      not null
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE), not null
#
class User < ApplicationRecord
  include Cacheable
  cacheable watch: %w[first_name last_name], bust: [
    { klass: 'TimeRange', ids: :time_range_ids },
    { klass: 'Plan', ids: :plan_ids }
  ]

  has_many :time_ranges, dependent: :destroy
  has_many :notes, as: :subject, dependent: :destroy
  has_many(
    :notes_written,
    foreign_key: 'author_id',
    class_name: 'Note',
    dependent: :restrict_with_exception,
    inverse_of: 'author'
  )
  has_many :memberships, dependent: :destroy
  has_many :user_groups, through: :memberships
  has_many :plans, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :admin, inclusion: { in: [true, false] }

  def name
    "#{first_name} #{last_name}"
  end

  def lead?
    memberships.exists?(role: 'lead')
  end
end
