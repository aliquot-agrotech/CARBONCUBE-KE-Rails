class Vendor < ApplicationRecord
  belongs_to :purchaser
  has_and_belongs_to_many :categories
  has_many :products
  has_many :orders
  has_many :reviews, through: :products

  validates :name, presence: true
  validates :business_number_registration, presence: true
  # Other validations...
end