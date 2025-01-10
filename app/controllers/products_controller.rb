class ProductsController < ApplicationController
  # GET /products
  def index
    # Fetch products from vendors subscribed to the premium tier
    @products = Product.joins(:vendor)
                      .where(vendors: { blocked: false, tier_id: 4 }) # Tier ID 4 corresponds to "Premium"
                      .where(flagged: false) # Exclude flagged products
                      .distinct
                      .sample(3) # Select three random products

    # Map over the products and modify the media_urls to include only the first URL
    @products = @products.map do |product|
      product.as_json.merge(first_media_url: product.media.first.try(:url)) # Extract the first media URL
    end

    render json: @products, each_serializer: ProductSerializer
  end
end
