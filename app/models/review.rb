class Review < ApplicationRecord
  belongs_to :product
  belongs_to :purchaser
  after_save :check_vendor_rating


  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :review, presence: true

  private

  def check_vendor_rating
    product.vendor.check_and_block
  end
end
