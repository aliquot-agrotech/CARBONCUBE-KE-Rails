class Seller::NotificationsController < ApplicationController
  before_action :authenticate_vendor

  def index
    notifications = current_vendor.notifications.order(created_at: :desc)
    render json: notifications
  end

  def create
    notification = Notification.create!(notification_params)
    NotificationsChannel.broadcast_to(
      current_vendor,
      notification: notification.as_json
    )
    head :ok
  end

  private

  def authenticate_vendor
    @current_user = SellerAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def notification_params
    params.require(:notification).permit(:order_id, :status, :issue)
          .merge(notifiable: @current_user)
  end

  def current_vendor
    @current_user
  end
end
