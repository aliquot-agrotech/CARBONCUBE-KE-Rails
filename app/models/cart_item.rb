# app/models/cart_item.rb

class CartItem < ApplicationRecord
  belongs_to :purchaser
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  before_save :set_price

  def total_price
    price * quantity
  end

  private

  def set_price
    self.price = product.price
  end
end
