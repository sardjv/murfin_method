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
  DEFAULT_START_DATE = (if ENV['PLAN_DEFAULT_START_MONTH']
                          Date.current.change(month: ENV['PLAN_DEFAULT_START_MONTH'].to_i)
                        else
                          Date.current
                        end).beginning_of_month
  DEFAULT_END_DATE = (DEFAULT_START_DATE + 11.months).end_of_month

  include Cacheable
  cacheable watch: %w[start_date end_date], bust: [{ klass: 'User', ids: :user_id }]

  belongs_to :user
  has_many :activities, dependent: :destroy
  accepts_nested_attributes_for :activities, allow_destroy: true
  has_many :signoffs, dependent: :destroy

  after_initialize :set_default_range

  accepts_nested_attributes_for :signoffs, allow_destroy: true

  validates :start_date, :end_date, presence: true
  validate :validate_end_date_after_start_date

  def validate_end_date_after_start_date
    return unless start_date && end_date && end_date <= start_date

    errors.add :end_date, 'must occur after start date'
  end

  def name
    "#{user.name}'s #{start_date.year} #{Plan.model_name.human.titleize}"
  end

  def to_time_ranges
    Rails.cache.fetch(activities_cache_key, expires_in: 1.week) do
      activities.flat_map(&:to_time_ranges)
    end
  end

  def state
    return :draft unless user_signoff&.signed?

    return :complete if signoffs.all?(&:signed?)

    :submitted
  end

  def draft?
    state == :draft
  end

  def submitted?
    state == :submitted
  end

  def complete?
    state == :complete
  end

  def required_signoffs
    signoffs.build(user_id: user_id) unless user_signoff

    signoffs
  end

  private

  def set_default_range
    self.start_date ||= DEFAULT_START_DATE
    self.end_date ||= DEFAULT_END_DATE
  end

  # Use updated_at.to_f here because the default is only accurate to
  # the second and can lead to tricky bugs, e.g. if 2 updates happen
  # within 1 second. Also makes for a shorter key.
  # "2021-01-29 13:52:43 UTC" vs "1611928363.130215"
  def activities_cache_key
    "Plan#to_time_ranges##{id}##{updated_at.to_f}"
  end

  def user_signoff
    signoffs.detect { |so| so.user_id == user_id } # detect because we want check within builded (not saved) relations too
  end
end
