class FlashMessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "flash_messages:#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
