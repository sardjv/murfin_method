# == Schema Information
#
# Table name: plans
#
#  id         :bigint           not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Plan < ApplicationRecord
  include CacheBuster

  belongs_to :user
  has_many :activities, dependent: :destroy
  accepts_nested_attributes_for :activities, allow_destroy: true

  validates :start_date, :end_date, :user_id, presence: true
  validate :validate_end_date_after_start_date

  def validate_end_date_after_start_date
    return unless start_date && end_date && end_date <= start_date

    errors.add :end_date, 'must occur after start date'
  end

  def name
    "#{user.name}'s #{start_date.year} #{I18n.t('plan.name')}"
  end

  def self.default_length
    1.year - 1.day
  end

  def to_time_ranges
    activities.flat_map(&:to_time_ranges)
  end

  private

  def bust_caches
    return unless saved_changes_include?(%w[start_date end_date])

    CacheBusterJob.perform_later(klass: 'User', ids: [user_id])
  end
end
