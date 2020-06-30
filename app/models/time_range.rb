# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :integer          not null
#  time_range_type_id :bigint           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class TimeRange < ApplicationRecord
  belongs_to :user
  belongs_to :time_range_type

  validates :start_time, :end_time, :value, :time_range_type_id, :user_id, presence: true
  validate :validate_end_time_after_start_time

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time < start_time

    errors.add :end_time, 'must occur after start time'
  end

  def segment_value(segment_start:, segment_end:)
    value * Intersection.proportion(
      a_start: start_time,
      a_end: end_time,
      b_start: segment_start,
      b_end: segment_end
    )
  end

  private

  def segment_proportion(segment_start:, segment_end:)
    if intersects_inside?(segment_start: segment_start, segment_end: segment_end)
      (segment_end - segment_start) / (end_time - start_time)
    elsif intersects_outside?(segment_start: segment_start, segment_end: segment_end)
      1
    elsif intersects_from_start?(segment_end: segment_end)
      (segment_end - start_time) / (end_time - start_time)
    elsif intersects_to_end?(segment_start: segment_start)
      (end_time - segment_start) / (end_time - start_time)
    else
      0
    end
  end

  def intersects_inside?(segment_start:, segment_end:)
    (segment_start >= start_time) && (segment_end <= end_time)
  end

  def intersects_outside?(segment_start:, segment_end:)
    (segment_start < start_time) && (segment_end > end_time)
  end

  def intersects_from_start?(segment_end:)
    (segment_end >= start_time) && (segment_end <= end_time)
  end

  def intersects_to_end?(segment_start:)
    (segment_start >= start_time) && (segment_start <= end_time)
  end
end
