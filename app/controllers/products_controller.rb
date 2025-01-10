class ProductsController < ApplicationController
  # GET /products
  def index
    # Fetch products from vendors subscribed to the premium tier
    @products = Product.joins(:vendor)
                      .where(vendors: { blocked: false, tier_id: 4 }) # Tier ID 4 corresponds to "Premium"
                      .where(flagged: false) # Exclude flagged products
                      .distinct
                      .sample(3) # Select three random products

    # Extract the first media URL for each product
    @products = @products.map do |product|
      product.media_urls = [product.media_urls.first] if product.media_urls.present?
      product
    end

    render json: @products, each_serializer: ProductSerializer
  end
end
