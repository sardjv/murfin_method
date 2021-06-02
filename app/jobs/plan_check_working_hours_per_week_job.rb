# frozen_string_literal: true

class PlanCheckWorkingHoursPerWeekJob < ApplicationJob
  queue_as :default

  #include CableReady::Broadcaster

  # from team start presenter, move to lib ruby extensions
  def weeks_between(from:, to:)
    raise ArgumentError, 'from must be before to' if from >= to

    (from.to_date..to.to_date)
      .map(&:beginning_of_week)
      .uniq
      .map { |w| w.to_time.in_time_zone }
  end


  def perform(*args) # rubocop:disable Metrics/AbcSize
    options = args.extract_options!
    plan_id = options[:plan_id]

    return unless plan_id

    plan = Plan.find plan_id

    pp plan

    pp weeks_between(from: plan.start_date, to: plan.end_date)

    # team_stats_presenter.weeks.each do |week_start|
    #   range = week_start.to_date..week_start.end_of_week.to_date

    #   planned_minutes = planned_time_ranges.sum do |tr|
    #     tr.segment_value(segment_start: range.begin.beginning_of_day, segment_end: range.end.end_of_day)
    #   end

    #   actual_minutes = actual_time_ranges.sum do |tr|
    #     tr.segment_value(segment_start: range.begin.beginning_of_day, segment_end: range.end.end_of_day)
    #   end

    #   percentage = planned_minutes ? Numeric.percentage_rounded(actual_minutes, planned_minutes) : nil

    #   weeks_data[range] = { planned_minutes: planned_minutes, actual_minutes: actual_minutes, percentage: percentage }
    # end

    # channel_name = "flash_messages:#{current_user_id}"

    # begin
    #   csv_data = CsvExport::Plans.call(plans: Plan.includes(:user, activities: %i[tags tag_types]).order(updated_at: :desc))
    # rescue StandardError
    #   FlashMessageBroadcastJob.perform_now(
    #     current_user_id: current_user_id,
    #     message: I18n.t('download.errors.processing', records_type: 'plans', file_type: 'CSV'),
    #     alert_type: 'danger',
    #     extra_data: { message_type: 'download' }
    #   )
    # end

    # redis_key = "plans_#{Date.current}_#{current_user_id}.csv"
    # REDIS_CLIENT.set(redis_key, csv_data)

    # # delete download related previous flash messages
    # selector_download_ready_message = "#flash-container .alert[data-message-type='download']"
    # cable_ready[channel_name].remove(select_all: true, selector: selector_download_ready_message)
    # cable_ready.broadcast

    # # show flash message with download link
    # path = Rails.application.routes.url_helpers.download_admin_plans_path(format: :csv)
    # link_html = link_to I18n.t('actions.download'), path, data: { turbo: false }

    # FlashMessageBroadcastJob.perform_now(
    #   current_user_id: current_user_id,
    #   message: raw(I18n.t('download.ready', records_type: 'plans', file_type: 'CSV', link: link_html)), # rubocop:disable Rails/OutputSafety
    #   alert_type: 'success',
    #   extra_data: { message_type: 'download' }
    # )
  end
end
