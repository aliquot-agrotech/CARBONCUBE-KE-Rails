class Admin::NotificationsController < ApplicationController
  before_action :authenticate_admin

  def create
    notification = Notification.create!(notification_params)
    NotificationsChannel.broadcast_to(
      current_admin,
      notification: render_to_string(partial: 'notification', locals: { notification: notification })
    )
    head :ok
  end

  private

  def notification_params
    params.require(:notification).permit(:order_id, :status)
          .merge(notifiable: current_admin)  # Assign current_admin to notifiable
  end
end
