class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :order

  # Validations or other code
end
