# frozen_string_literal: true

class UserStatsPresenter
  attr_accessor :user, :filter_start_time, :filter_end_time, :filter_tag_ids, :actual_id

  OVER_MIN_PERCENTAGE = 120
  OK_MIN_PERCENTAGE = 80
  UNDER_MIN_PERCENTAGE = 50

  def initialize(args)
    args = defaults.merge(args)
    @user = args[:user]
    @filter_start_time = args[:filter_start_date].to_time.in_time_zone.beginning_of_day
    @filter_end_time = args[:filter_end_date].to_time.in_time_zone.end_of_day
    @filter_tag_ids = args[:filter_tag_ids]
    @actual_id = args[:actual_id]
    @cache = {}
  end

  def average_weekly_planned
    return nil if no_planned_data?

    average_weekly(planned_time_ranges)
  end

  def average_weekly_actual
    return nil if no_actual_data?

    average_weekly(actual_time_ranges)
  end

  def percentage_delivered
    return nil if no_planned_data? || no_actual_data?

    Numeric.percentage_rounded(total(actual_time_ranges), total(planned_time_ranges))
  end

  def status
    percentage = percentage_delivered
    # no planned or actual data - Unknown
    return I18n.t('status.unknown') if percentage.nil?
    # 120+ - Over
    return I18n.t('status.over') if percentage >= OVER_MIN_PERCENTAGE
    # 80 to 119 - About Right
    return I18n.t('status.about_right') if percentage >= OK_MIN_PERCENTAGE
    # 50 to 79 - Under
    return I18n.t('status.under') if percentage >= UNDER_MIN_PERCENTAGE

    # 0 to 49 - Really Under
    I18n.t('status.really_under')
  end

  def actual_time_ranges
    return @cache[:actual_time_ranges] if @cache[:actual_time_ranges].present?

    @cache[:actual_time_ranges] = calculate_actual_time_ranges
  end

  def planned_time_ranges
    return @cache[:planned_time_ranges] if @cache[:planned_time_ranges].present?

    @cache[:planned_time_ranges] = calculate_planned_time_ranges
  end

  def total(time_ranges)
    time_ranges.sum do |t|
      t.segment_value(
        segment_start: filter_start_time,
        segment_end: filter_end_time
      )
    end
  end

  private

  def defaults
    {
      actual_id: TimeRangeType.actual_type.id,
      filter_start_date: (1.year.ago + 1.day).to_date,
      filter_end_date: Date.current,
      filter_tag_ids: Tag.where(default_for_filter: true).pluck(:id)
    }
  end

  def average_weekly(time_ranges)
    total = total(time_ranges)
    result = (total.to_f / number_of_weeks)
    return 0 if result.nan? || result.infinite?

    result.round(1)
  end

  def number_of_weeks
    (filter_end_time - filter_start_time) / 1.week
  end

  def no_planned_data?
    planned_time_ranges.empty?
  end

  def no_actual_data?
    actual_time_ranges.empty?
  end

  def calculate_actual_time_ranges
    scope = user_actual_time_ranges

    scope = scope.where('start_time BETWEEN ? AND ?', filter_start_time, filter_end_time).or(
      scope.where('end_time BETWEEN ? AND ?', filter_start_time, filter_end_time)
    ).or(
      scope.where('start_time <= ? AND end_time >= ?', filter_start_time, filter_end_time)
    ).distinct

    scope = scope.filter_by_tag_types_and_tags(filter_tag_ids) if filter_tag_ids.present?
    # scope = scope.joins(:tags).where(tags: { id: filter_tag_ids }) if filter_tag_ids.any?

    scope.distinct.to_a
  end

  def calculate_planned_time_ranges
    user_plan_time_ranges.select do |a|
      Intersection.call(a_start: a.start_time, a_end: a.end_time, b_start: filter_start_time, b_end: filter_end_time).positive?
    end
  end

  def user_plan_time_ranges
    scope = Activity.joins(:plan).where(plans: { user_id: user.id })
    # scope = scope.joins(:tags).where(tags: { id: filter_tag_ids }) if filter_tag_ids.any?
    scope = scope.filter_by_tag_types_and_tags(filter_tag_ids) if filter_tag_ids.present?
    scope.distinct.flat_map(&:to_time_ranges)
  end

  def user_actual_time_ranges
    user.time_ranges.where(time_range_type_id: actual_id)
  end
end
