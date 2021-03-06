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
  include Cacheable
  include Taggable

  cacheable watch: %w[schedule], bust: [{ klass: 'User', ids: %i[plan user_id] }]

  belongs_to :plan, touch: true

  validates :schedule, presence: true
  validate :validate_end_time_after_start_time

  def seconds_per_week=(seconds)
    self.schedule = ScheduleBuilder.call(
      schedule: schedule,
      minutes_per_week: seconds.to_f / 60
    )
  end

  def seconds_per_week
    return unless schedule

    ScheduleParser.call(schedule: schedule)[:minutes_per_week] * 60.0
  end

  def days
    return unless schedule

    # Only handle 1 rule per activity for now.
    ScheduleParser.call(schedule: schedule)[:rules].first[:days]
  end

  def start_time
    schedule&.start_time
  end

  def end_time
    schedule&.end_time
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

  def to_time_ranges # rubocop:disable Metrics/AbcSize
    Rails.cache.fetch(time_ranges_cache_key, expires_in: 1.week) do
      schedule.occurrences_between(plan.start_date.beginning_of_day, plan.end_date.end_of_day).map do |o|
        TimeRange.new(
          start_time: o.start_time,
          end_time: o.end_time,
          value: o.duration / 60, # Duration in minutes.
          user_id: plan.user_id
        )
      end
    end
  end

  private

  # Use updated_at.to_f here because the default is only accurate to
  # the second and can lead to tricky bugs, e.g. if 2 updates happen
  # within 1 second. Also makes for a shorter key.
  # "2021-01-29 13:52:43 UTC" vs "1611928363.130215"
  def time_ranges_cache_key
    "Activity#to_time_ranges##{id}##{updated_at.to_f}"
  end

  def time_value(hash)
    # Store time values on the same day so the duration of each occurrence is correct.
    Time.zone.local(1, 1, 1, hash[4], hash[5])
  end

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :duration, I18n.t('errors.activity.duration.missing')
  end
end
