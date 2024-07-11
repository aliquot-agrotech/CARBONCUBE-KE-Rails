# app/models/invoice.rb
class Invoice < ApplicationRecord
  belongs_to :order

  # Validation for presence of mpesa_transaction_code and total_amount
  validates :mpesa_transaction_code, presence: true
  validates :total_amount, presence: true
end
