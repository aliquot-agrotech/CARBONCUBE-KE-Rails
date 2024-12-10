class BuyForMeOrder < ApplicationRecord
  belongs_to :product
  belongs_to :purchaser

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
