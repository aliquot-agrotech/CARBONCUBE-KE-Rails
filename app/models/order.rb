# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :purchaser
  has_many :order_items, dependent: :destroy
  has_many :order_vendors, dependent: :destroy
  has_many :products, through: :order_items
  has_many :vendors, through: :order_vendors
  has_one :invoice, dependent: :destroy

  before_save :calculate_total_amount

  accepts_nested_attributes_for :order_items, allow_destroy: true
  accepts_nested_attributes_for :order_vendors, allow_destroy: true

  validates :status, inclusion: { in: %w[processing on-transit delivered] }
  validates :mpesa_transaction_code, presence: true

  private

  def calculate_total_amount
    self.total_amount = order_items.sum { |item| item.quantity * item.price }
  end
end
