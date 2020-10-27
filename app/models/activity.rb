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

  def day
    return unless schedule

    # Only handle 1 rule per activity for now.
    ScheduleParser.call(schedule: schedule)[:rules].first[:day]
  end

  def day=(day_string)
    self.schedule = ScheduleBuilder.call(
      start_time: start_time,
      rules: [{ type: :weekly, day: day_string }]
    )
  end

  def start_time
    schedule&.start_time
  end

  def start_time=(time)
    self.schedule = ScheduleBuilder.call(
      start_time: time.change(
        year: plan.start_date.year,
        month: plan.start_date.month,
        day: plan.start_date.day
      ),
      rules: ScheduleParser.call(schedule: schedule)[:rules]
    )
  end

  # Deserialize from YAML storage.
  def schedule
    return if super.nil? # schedule can be nil sometimes, e.g. before the object is saved.

    IceCube::Schedule.from_yaml(super)
  end

  # Serialize to YAML for storage.
  def schedule=(ice_cube_schedule)
    super(ice_cube_schedule.to_yaml)
  end
end
