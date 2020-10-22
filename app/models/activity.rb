# == Schema Information
#
# Table name: activities
#
#  id                 :bigint           not null, primary key
#  schedule           :mediumtext       not null
#  plan_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Activity < ApplicationRecord
  belongs_to :plan

  validates :schedule, presence: true

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
