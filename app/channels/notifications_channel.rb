class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_admin
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
