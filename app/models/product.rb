class Product < ApplicationRecord
  belongs_to :vendor
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true
  validates :media, presence: true
  validates :category_id, presence: true
  validates :vendor_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :brand, presence: true
  validates :manufacturer, presence: true
  validates :package_length, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :package_width, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :package_height, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :package_weight, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
