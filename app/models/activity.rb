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
  belongs_to :plan

  validates :schedule, presence: true
  validate :validate_end_time_after_start_time

  before_save :set_bounds

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

  # Pass a time_select hash, eg. { 1 => 2020, 2 => 10, 3 => 31, 4 => 9, 5 => 30 }
  def start_time=(time)
    self.schedule = ScheduleBuilder.call(
      schedule: schedule,
      start_time: time_value(time)
    )
  end

  def end_time
    schedule&.end_time
  end

  # Pass a time_select hash, eg. { 1 => 2020, 2 => 10, 3 => 31, 4 => 9, 5 => 30 }
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
    schedule.occurrences
  end

  private

  def time_value(hash)
    Time.zone.local(hash[1] || 1, hash[2] || 1, hash[3] || 1, hash[4], hash[5])
  end

  def set_bounds
    set_time_to_date(field: :start_time, date: plan.start_date)
    set_time_to_date(field: :end_time, date: plan.end_date)
  end

  def set_time_to_date(field:, date:)
    assign_attributes(
      field => {
        1 => date.year,
        2 => date.month,
        3 => date.day,
        4 => send(field).strftime('%H'),
        5 => send(field).strftime('%M')
      }
    )
  end

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :end_time, 'must occur after start time'
  end
end
