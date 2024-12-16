class ProductSearchSerializer < ActiveModel::Serializer
  attributes :id, :search_term, :purchaser_id, :created_at, :updated_at

  # Optional: Include user details if associated
  belongs_to :purchaser, if: -> { object.purchaser.present? }

  # Example of custom formatting for `created_at`
  attribute :formatted_created_at do
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
