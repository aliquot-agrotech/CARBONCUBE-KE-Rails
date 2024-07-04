class Review < ApplicationRecord
  belongs_to :product
  belongs_to :purchaser

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :review, presence: true
end
