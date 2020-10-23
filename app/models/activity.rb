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
  belongs_to :plan, touch: true

  validates :schedule, :plan_id, presence: true

  # Deserialize from YAML storage.
  def schedule
    IceCube::Schedule.from_yaml(super)
  end

  # Serialize to YAML for storage.
  def schedule=(ice_cube_schedule)
    super(ice_cube_schedule.to_yaml)
  end
end
