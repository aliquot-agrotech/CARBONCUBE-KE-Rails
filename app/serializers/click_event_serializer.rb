class ClickEventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :product_id, :purchaser_id, :metadata, :created_at, :updated_at

  # Optional: Include associated product and user details
  belongs_to :product, if: -> { object.product.present? }
  belongs_to :purchaser, if: -> { object.purchaser.present? }

  # Example of custom serialization for metadata
  attribute :metadata do
    object.metadata || {}
  end

  # Example of custom formatting for `created_at`
  attribute :formatted_created_at do
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
