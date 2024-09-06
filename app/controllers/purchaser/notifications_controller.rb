class Purchaser::NotificationsController < ApplicationController
  before_action :authenticate_purchaser

  def index
    notifications = current_purchaser.notifications.order(created_at: :desc)
    render json: notifications
  end

  def create
    notification = Notification.create!(notification_params)
    NotificationsChannel.broadcast_to(
      current_purchaser,
      notification: notification.as_json
    )
    head :ok
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def notification_params
    params.require(:notification).permit(:order_id, :status, :issue)
          .merge(notifiable: @current_user)
  end

  def current_purchaser
    @current_user
  end
end
