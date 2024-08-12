class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_for Admin.find(params[:admin_id])
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
