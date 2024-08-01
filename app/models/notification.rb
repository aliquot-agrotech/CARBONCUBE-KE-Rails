class Notification < ApplicationRecord
  belongs_to :product
  belongs_to :vendor
  validates :options, presence: true
end