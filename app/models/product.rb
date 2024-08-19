class Product < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_by_title_and_description, 
  against: [:title, :description],
  using: {
    tsearch: { prefix: true },
    trigram: {}
  }

  scope :all_products, -> { unscope(:where).all }

  belongs_to :vendor
  belongs_to :category
  belongs_to :subcategory
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :purchasers, through: :bookmarks

  validates :title, :description, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight, presence: true
  validates :price, :quantity, :package_length, :package_width, :package_height, numericality: true
  validates :package_weight, numericality: { greater_than: 0 }

  # Ensure media can accept a string or array of strings
  serialize :media, coder: JSON

   # Soft delete
   def flag
    update(flagged: true)
  end

  # Restore flagged product
  def unflag
    update(flagged: false)
  end
end
