class ProductSearch < ApplicationRecord
  belongs_to :user, optional: true

  validates :search_term, presence: true

  # Scope to find the most popular searches
  scope :popular_searches, ->(limit = 10) {
    group(:search_term).order('COUNT(search_term) DESC').limit(limit).count
  }
end
