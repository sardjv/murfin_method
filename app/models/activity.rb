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

  # Deserialize from YAML storage.
  def schedule
    return unless super

    IceCube::Schedule.from_yaml(super)
  end

  # Serialize to YAML for storage.
  def schedule=(ice_cube_schedule)
    if ice_cube_schedule.is_a?(IceCube::Schedule)
      super(ice_cube_schedule.to_yaml)
    else
      super(ice_cube_schedule)
    end
  end
end
