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
  include Cacheable
  cacheable watch: %w[start_date end_date], bust: [{ klass: 'User', ids: :user_id }]

  belongs_to :user
  has_many :activities, dependent: :destroy
  accepts_nested_attributes_for :activities, allow_destroy: true
  has_many :signoffs, dependent: :destroy
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

  def self.default_length
    1.year - 1.day
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
    signoffs.build(user_id: user_id) if user_signoff.blank?

    signoffs
  end

  private

  def activities_cache_key
    "Plan#to_time_ranges##{id}##{updated_at.to_f}"
  end

  def user_signoff
    signoffs.find_by(user_id: user_id)
  end
end
