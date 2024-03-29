# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :decimal(65, 30)  not null
#  time_range_type_id :bigint           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  appointment_id     :string(255)
#
class TimeRange < ApplicationRecord
  strip_attributes only: %i[appointment_id]

  include Taggable

  belongs_to :user, touch: true
  belongs_to :time_range_type

  validates :start_time, :end_time, :value, presence: true
  validate :validate_value_positive

  validates :appointment_id, uniqueness: { case_sensitive: true }, allow_blank: true
  validate :validate_end_time_after_start_time

  def seconds_worked=(seconds)
    self.value = seconds.to_f / 60
  end

  def seconds_worked
    (value || 0) * 60.0
  end

  # how many minutes from time range overlaps with given segment
  def segment_value(segment_start:, segment_end:)
    value * Intersection.call(
      a_start: start_time,
      a_end: end_time,
      b_start: segment_start,
      b_end: segment_end
    )
  end

  private

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :end_time, I18n.t('errors.time_range.end_time.should_be_after_start_time')
  end

  # requires custom validation because value is BigDecimal
  def validate_value_positive
    return if value&.to_f&.positive?

    errors.add :value, :greater_than, count: 0
  end
end
