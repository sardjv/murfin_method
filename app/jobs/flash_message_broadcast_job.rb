# frozen_string_literal: true

class FlashMessageBroadcastJob < ApplicationJob
  queue_as :default

  include CableReady::Broadcaster
  include ActionView::Helpers::TagHelper # for content_tag

  FLASH_CONTAINER_SELECTOR = '#flash-container'
  CHANNEL_NAME_BASE = 'flash_messages'

  def perform(*args)
    options = args.extract_options!

    return unless options[:message]
    return unless options[:current_user_id]

    alert_type = options[:alert_type] || 'info'

    html = tag.div(options[:message], class: "alert alert-#{alert_type}", role: 'alert', data: options[:extra_data] || {})

    channel_name = "#{CHANNEL_NAME_BASE}:#{options[:current_user_id]}"
    cable_ready[channel_name].insert_adjacent_html(selector: FLASH_CONTAINER_SELECTOR, position: 'beforeend', html: html)
    cable_ready.broadcast
  end
end
