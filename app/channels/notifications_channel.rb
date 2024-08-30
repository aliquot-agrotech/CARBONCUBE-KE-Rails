class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    if params[:admin_id]
      stream_for Admin.find(params[:admin_id])
    elsif params[:vendor_id]
      stream_for Vendor.find(params[:vendor_id])
    elsif params[:purchaser_id]
      stream_for Purchaser.find(params[:purchaser_id])
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
