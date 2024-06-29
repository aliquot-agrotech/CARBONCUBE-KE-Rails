class Order < ApplicationRecord
  belongs_to :purchaser
  belongs_to :vendor

  validates :status, presence: true
  validates :total_amount, presence: true
end