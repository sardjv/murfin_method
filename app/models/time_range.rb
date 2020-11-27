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
#
class TimeRange < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :time_range_type

  validates :start_time, :end_time, :value, presence: true
  validate :validate_end_time_after_start_time

  def seconds_worked=(seconds)
    self.value = seconds.to_f / 60
  end

  def seconds_worked
    (value || 0) * 60.0
  end

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :end_time, 'must occur after start time'
  end

  def segment_value(segment_start:, segment_end:)
    value * Intersection.call(
      a_start: start_time,
      a_end: end_time,
      b_start: segment_start,
      b_end: segment_end
    )
  end
end
