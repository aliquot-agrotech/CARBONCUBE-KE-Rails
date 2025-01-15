# app/models/cart_item.rb

class BuyForMeOrderCartItem < ApplicationRecord
  belongs_to :purchaser
  belongs_to :ad

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  before_save :set_price

  def total_price
    price * quantity
  end

  private

  def set_price
    self.price = ad.price
  end
end
