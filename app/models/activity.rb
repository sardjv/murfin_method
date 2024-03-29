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

  validates :plan, presence: true
  validates :schedule, presence: true
  validate :validate_end_time_after_start_time
  before_validation :build_schedule, unless: :skip_build_schedule?

  attr_writer :seconds_per_week

  after_update { delay.to_bulk_time_range }

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

  # only used in FakeGraphDataJob now
  def to_time_ranges(filter_start_time = nil, filter_end_time = nil) # rubocop:disable Metrics/AbcSize
    range_start = (filter_start_time || plan.start_date).beginning_of_day
    range_end = (filter_end_time || plan.end_date).end_of_day

    cache_key = "#{to_time_ranges_cache_key}##{range_start.to_date}-#{range_end.to_date}"

    Rails.cache.fetch(cache_key, expires_in: 1.week) do
      schedule.occurrences_between(range_start, range_end).map do |o|
        TimeRange.new(
          start_time: o.start_time,
          end_time: o.end_time,
          value: o.duration / 60, # Duration in minutes.
          user_id: plan.user_id
        )
      end
    end
  end

  def to_bulk_time_range(filter_start_time = nil, filter_end_time = nil) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
    cache_key = if filter_start_time && filter_end_time
                  "#{to_bulk_time_range_cache_key}##{filter_start_time.to_date}-#{filter_end_time.to_date}"
                else
                  to_bulk_time_range_cache_key
                end

    Rails.cache.fetch(cache_key, expires_in: 1.week) do
      if filter_start_time && filter_end_time
        filter_range = filter_start_time.beginning_of_day..filter_end_time.end_of_day
        plan_range = plan.start_date.beginning_of_day..plan.end_date.end_of_day
        occurences_range = filter_range.intersection plan_range
      else
        occurences_range = plan.start_date.beginning_of_day..plan.end_date.end_of_day
      end

      occurences = schedule.occurrences_between(occurences_range.begin, occurences_range.end)
      bulk_time_range_value = occurences.sum(&:duration) / 60

      # plan_days = (plan.end_date.end_of_day - plan.start_date.beginning_of_day).seconds.in_days.to_i.abs
      # bulk_time_range_value = (seconds_per_week.to_f / 60 / 7) * plan_days

      TimeRange.new(
        start_time: plan.start_date.beginning_of_day,
        end_time: plan.end_date.end_of_day,
        value: bulk_time_range_value,
        user_id: plan.user_id
      )
    end
  end

  def build_schedule
    return unless plan

    activity_start_time = plan.start_date.beginning_of_day
    self.schedule = ScheduleBuilder.call(
      start_time: activity_start_time,
      schedule: schedule,
      minutes_per_week: @seconds_per_week.to_f / 60
    )
  end

  private

  def skip_build_schedule?
    new_record? && schedule
  end

  # Use updated_at.to_f here because the default is only accurate to
  # the second and can lead to tricky bugs, e.g. if 2 updates happen
  # within 1 second. Also makes for a shorter key.
  # "2021-01-29 13:52:43 UTC" vs "1611928363.130215"
  def to_time_ranges_cache_key
    "Activity#to_time_ranges##{id}##{updated_at.to_f}"
  end

  def to_bulk_time_range_cache_key
    "Activity#to_bulk_time_range##{id}##{updated_at.to_f}"
  end

  def validate_end_time_after_start_time
    return unless start_time && end_time && end_time <= start_time

    errors.add :duration, I18n.t('errors.activity.duration.missing')
  end
end
