# frozen_string_literal: true

class GeneratePlansCsvJob < ApplicationJob
  queue_as :default

  include CableReady::Broadcaster
  include ActionView::Helpers::UrlHelper # for link_to

  def perform(*args) # rubocop:disable Metrics/AbcSize
    options = args.extract_options!
    current_user_id = options[:current_user_id]

    return unless current_user_id

    channel_name = "flash_messages:#{current_user_id}"

    begin
      csv_data = CsvExport::Plans.call(plans: Plan.includes(:user, activities: %i[tags tag_types]).order(updated_at: :desc))
    rescue StandardError
      FlashMessageBroadcastJob.perform_now(
        current_user_id: current_user_id,
        message: I18n.t('download.errors.processing', records_type: 'plans', file_type: 'CSV'),
        alert_type: 'danger',
        extra_data: { message_type: 'download' }
      )
    end

    redis_key = "plans_#{Date.current}_#{current_user_id}.csv"
    REDIS_CLIENT.set(redis_key, csv_data)

    # delete download related previous flash messages
    selector_download_ready_message = "#flash-container .alert[data-message-type='download']"
    cable_ready[channel_name].remove(select_all: true, selector: selector_download_ready_message)
    cable_ready.broadcast

    # show flash message with download link
    path = Rails.application.routes.url_helpers.download_admin_plans_path(format: :csv)
    link_html = link_to I18n.t('actions.download'), path, data: { turbo: false }

    FlashMessageBroadcastJob.perform_now(
      current_user_id: current_user_id,
      message: raw(I18n.t('download.ready', records_type: 'plans', file_type: 'CSV', link: link_html)), # rubocop:disable Rails/OutputSafety
      alert_type: 'success',
      extra_data: { message_type: 'download' }
    )
  end
end
