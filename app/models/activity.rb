# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  schedule   :text(16777215)   not null
#  plan_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Activity < ApplicationRecord
  include CacheBuster

  belongs_to :plan

  validates :schedule, presence: true
  validate :validate_end_time_after_start_time

  def day
    return unless schedule

    # Only handle 1 rule per activity for now.
    ScheduleParser.call(schedule: schedule)[:rules].first[:day]
  end

  def day=(day_string)
    self.schedule = ScheduleBuilder.call(
      schedule: schedule,
      rules: [{ type: :weekly, day: day_string }]
    )
  end

  def start_time
    schedule&.start_time
  end

  # Pass a time_select hash, eg. { 4 => 9, 5 => 30 }
  def start_time=(time)
    self.schedule = ScheduleBuilder.call(
      schedule: schedule,
      start_time: time_value(time)
    )
  end

  def end_time
    schedule&.end_time
  end

  # Pass a time_select hash, eg. { 4 => 17, 5 => 0 }
  def end_time=(time)
    self.schedule = ScheduleBuilder.call(
      schedule: schedule,
      end_time: time_value(time)
    )
  end

  # Deserialize from YAML storage.
  def schedule
    return if super.nil? # schedule can be nil sometimes, e.g. before the object is saved.

    IceCube::Schedule.from_yaml(super)
  end

  # Serialize to YAML for storage.
  # Pass an IceCube::Schedule.
  def schedule=(ice_cube_schedule)
    super(ice_cube_schedule.to_yaml)
  end

  def to_time_ranges
    schedule.occurrences_between(plan.start_date.beginning_of_day, plan.end_date.end_of_day).map do |o|
      TimeRange.new(
        start_time: o.start_time,
        end_time: o.end_time,
        value: o.duration / 60, # Duration in minutes.
        user_id: plan.user_id
      )
    end
  end

  private

  def time_value(hash)
    # Store time values on the same day so the duration of each occurrence is correct.
    Time.zone.local(1, 1, 1, hash[4], hash[5])
  end

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :end_time, 'must occur after start time'
  end

  def bust_caches
    return unless saved_changes_include?(%w[schedule])

    CacheBusterJob.perform_later(klass: 'User', ids: [plan.user_id])
  end
end
