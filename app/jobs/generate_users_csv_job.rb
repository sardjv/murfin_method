# frozen_string_literal: true

class GenerateUsersCsvJob < ApplicationJob
  queue_as :default

  include CableReady::Broadcaster
  include ActionView::Helpers::UrlHelper # for link_to

  def perform(*args) # rubocop:disable Metrics/AbcSize
    options = args.extract_options!
    current_user_id = options[:current_user_id]

    return unless current_user_id

    channel_name = "flash_messages:#{current_user_id}"

    csv = CsvExport::Users.call(users: User.order(last_name: :asc))
    file_name = "users_#{Date.current}_#{current_user_id}.csv"
    # path = Rails.root.join('tmp', file_name)

    begin
      # file = File.open(path, 'w')
      # file.write(csv)
      # file.close

      tmp_file_path = File.join(Dir.tmpdir, file_name)

      File.open(tmp_file_path, 'w')  do |tmp_file|
        tmp_file.write(csv)

        Rails.logger.info "===================== tmp_file.path #{tmp_file.path}"
      end

      # delete download related previous flash messages
      selector_download_ready_message = "#flash-container .alert[data-message-type='download']"
      cable_ready[channel_name].remove(select_all: true, selector: selector_download_ready_message)
      cable_ready.broadcast

      # show flash message with download link
      path = Rails.application.routes.url_helpers.download_admin_users_path(format: :csv)
      link_html = link_to I18n.t('actions.download'), path, data: { turbo: false }

      FlashMessageBroadcastJob.perform_now(
        current_user_id: current_user_id,
        message: raw(I18n.t('download.ready', records_type: 'users', file_type: 'CSV', link: link_html)), # rubocop:disable Rails/OutputSafety
        alert_type: 'success',
        extra_data: { message_type: 'download' }
      )
    # rescue StandardError
    #   FlashMessageBroadcastJob.perform_now(
    #     current_user_id: current_user_id,
    #     message: I18n.t('download.processing_error', records_type: 'users', file_type: 'CSV'),
    #     alert_type: 'danger',
    #     extra_data: { message_type: 'download' }
    #   )
    ensure
      file&.close
    end
  end
end
