class ReviewsController < ApplicationController
  def index
    product = Product.find(params[:id])
    reviews = product.reviews.includes(:purchaser)

    reviews_data = reviews.map do |review|
      {
        rating: review.rating,
        review: review.review,
        purchaser: {
          id: review.purchaser.id,
          name: review.purchaser.fullname
        }
      }
    end

    render json: reviews_data, status: :ok
  end
end
