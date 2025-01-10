# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  # GET /products
  def index
    # Fetch products from vendors subscribed to the premium tier
    @products = Product.joins(:vendor, :tier)
                      .where(vendors: { blocked: false }, tiers: { id: 4 }) # Tier ID 4 corresponds to "Premium"
                      .where(flagged: false) # Exclude flagged products
                      .distinct
                      .sample(3) # Select three random products

    render json: @products, each_serializer: ProductSerializer
  end
end
