# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  email                  :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  epr_uuid               :string(255)
#  ad_preferences         :text(65535)
#
class User < ApplicationRecord
  strip_attributes only: %i[first_name last_name email epr_uuid]
  # :confirmable, :lockable, :timeoutable, :recoverable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable, :rememberable

  include HasOptionalPassword
  include UsesActiveDirectory

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
    dependent: :restrict_with_error,
    inverse_of: 'author'
  )
  has_many :memberships, dependent: :destroy
  has_many :user_groups, through: :memberships
  has_many :plans, dependent: :destroy
  has_many :signoffs, dependent: :restrict_with_error

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :admin, inclusion: { in: [true, false] }
  validates :epr_uuid, uniqueness: { case_sensitive: true }, allow_blank: true

  ransacker :first_last_name do |parent|
    Arel::Nodes::NamedFunction.new('CONCAT_WS', [
                                     Arel::Nodes.build_quoted(' '), parent.table[:first_name], parent.table[:last_name]
                                   ])
  end

  ransacker :last_first_name do |parent|
    Arel::Nodes::NamedFunction.new('CONCAT_WS', [
                                     Arel::Nodes.build_quoted(' '), parent.table[:last_name], parent.table[:first_name]
                                   ])
  end

  def name
    "#{first_name} #{last_name}"
  end

  def lead?
    memberships.exists?(role: 'lead')
  end
end
