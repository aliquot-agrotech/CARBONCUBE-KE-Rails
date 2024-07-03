class Order < ApplicationRecord
  belongs_to :purchaser
  has_many :order_vendors
  has_many :order_items
  has_many :products, through: :order_items

  def total_amount
    order_items.sum('quantity * price')
  end
end