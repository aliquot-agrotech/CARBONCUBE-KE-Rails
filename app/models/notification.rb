class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :order

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    # Broadcast to the purchaser channel
    if notifiable.is_a?(Purchaser)
      PurchaserNotificationsChannel.broadcast_to(notifiable, notification: self.as_json)
    end

    # Broadcast to the vendor channel
    if notifiable.is_a?(Vendor)
      VendorNotificationsChannel.broadcast_to(notifiable, notification: self.as_json)
    end

    # Broadcast to the admin channel
    if notifiable.is_a?(Admin)
      AdminNotificationsChannel.broadcast_to(notifiable, notification: self.as_json)
    end
  end
end
