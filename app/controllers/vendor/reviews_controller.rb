
    class Vendor::ReviewsController < ApplicationController
      def index
        @reviews = Review.joins(:product).where(products: { vendor_id: current_vendor.id })
        render json: @reviews
      end
    end
  