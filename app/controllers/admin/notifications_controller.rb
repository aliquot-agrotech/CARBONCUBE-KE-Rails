# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  def create
    notification = Notification.create!(notification_params)
    NotificationsChannel.broadcast_to(
      Admin.find(notification.admin_id),
      notification: render_to_string(notification)
    )
    head :ok
  end

  private

  def notification_params
    params.require(:notification).permit(:admin_id, :order_id, :status, :created_at)
  end
end
