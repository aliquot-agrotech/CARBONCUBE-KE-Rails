class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :order

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    if self.purchaser_id
      NotificationsChannel.broadcast_to(Purchaser.find(self.purchaser_id), self)
    elsif self.vendor_id
      NotificationsChannel.broadcast_to(Vendor.find(self.vendor_id), self)
    elsif self.admin_id
      NotificationsChannel.broadcast_to(Admin.find(self.admin_id), self)
    end
  end
end
