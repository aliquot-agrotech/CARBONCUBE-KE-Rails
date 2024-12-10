class BuyForMeOrderItem < ApplicationRecord
  belongs_to :buy_for_me_order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total_price

  private

  def calculate_total_price
    self.price = product.price
    self.total_price = price * quantity
  end
end
  