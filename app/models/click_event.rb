class ClickEvent < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product, optional: true

  EVENT_TYPES = %w[Product-Click Reveal-Vendor-Details Add-to-Cart Add-to-Wish-List].freeze

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
  validates :metadata, presence: true, if: -> { event_type == 'Reveal-Vendor-Details' } # Example: require metadata for certain event types

  # Scope to find the most common click types
  scope :popular_events, ->(limit = 10) {
    group(:event_type).order('COUNT(event_type) DESC').limit(limit).count
  }

  # Scope to filter clicks by a specific product
  scope :for_product, ->(product_id) { where(product_id: product_id) }
end
