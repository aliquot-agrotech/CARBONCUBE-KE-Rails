# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :purchaser
  has_many :order_items
  has_many :products, through: :order_items
  has_many :vendors, through: :order_vendors

  before_save :calculate_total_amount

  private

  def calculate_total_amount
    self.total_amount = order_items.sum { |item| item.quantity * item.product.price }
  end
end
