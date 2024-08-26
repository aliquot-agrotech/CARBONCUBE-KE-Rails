class Order < ApplicationRecord
  belongs_to :purchaser
  has_many :order_items, dependent: :destroy
  has_many :order_vendors, dependent: :destroy
  has_many :products, through: :order_items
  has_many :vendors, through: :order_vendors

  before_save :calculate_total_amount

  accepts_nested_attributes_for :order_items, allow_destroy: true
  accepts_nested_attributes_for :order_vendors, allow_destroy: true

  validates :status, inclusion: { in: %w[Processing Dispatched On-Transit Delivered] }
  validates :mpesa_transaction_code, presence: true

  private

  def order_date
    created_at.strftime('%Y-%m-%d')
  end

  def total_price
    order_items.sum do |item|
      item.product ? item.quantity * item.product.price : 0
    end
  end

  def calculate_total_amount
    self.total_amount = order_items.sum do |item|
      item.product ? item.quantity * item.product.price : 0
    end
  end
end
