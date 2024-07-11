class Product < ApplicationRecord
  belongs_to :vendor
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates :title, :description, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight, presence: true
  validates :price, :quantity, :package_length, :package_width, :package_height, numericality: true
  validates :package_weight, numericality: { greater_than: 0 }

  # Ensure media can accept a string or array of strings
  serialize :media, coder: JSON
end