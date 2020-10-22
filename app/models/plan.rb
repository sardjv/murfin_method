# == Schema Information
#
# Table name: plans
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Plan < ApplicationRecord
  belongs_to :user
  has_many :activities, dependent: :destroy, inverse_of: :plan
  accepts_nested_attributes_for :activities, allow_destroy: true

  validates :start_time, :end_time, :user_id, presence: true
  validate :validate_end_time_after_start_time

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time < start_time

    errors.add :end_time, 'must occur after start time'
  end

  def name
    "#{user.name}'s #{start_time.year} #{I18n.t('plan.name')}"
  end
end
