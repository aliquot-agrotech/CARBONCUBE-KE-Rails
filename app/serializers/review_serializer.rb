class ReviewSerializer < ActiveModel::Serializer
    attributes :id, :rating, :review, :created_at, :updated_at
  
    belongs_to :ad
    belongs_to :purchaser
end
  