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
  belongs_to :plan, touch: true

  validates :schedule, :plan_id, presence: true
end
