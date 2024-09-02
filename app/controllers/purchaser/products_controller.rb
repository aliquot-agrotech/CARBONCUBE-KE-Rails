# app/controllers/purchaser/products_controller.rb
class Purchaser::ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /purchaser/products
  def index
    @products = Product.joins(:vendor)
                      .where(vendors: { blocked: false })
                      .where(flagged: false) # Exclude flagged products

    filter_by_category if params[:category_id].present?

    # Include associated media URLs
    products_with_media = @products.map do |product|
      product.as_json.merge(
        media_urls: product.media.map { |media| url_for(media) }
      )
    end

    render json: products_with_media
  end



  # GET /purchaser/products/:id
  def show
    render json: @product
  end

  # GET /purchaser/products/search
  def search
    query = params[:query].to_s.strip

    @products = Product.joins(:vendor, :category)
                       .where(vendors: { blocked: false })
                       .where('products.title ILIKE ? OR products.description ILIKE ? OR categories.name ILIKE ?', 
                              "%#{query}%", "%#{query}%", "%#{query}%")
                       .distinct

    render json: @products
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def filter_by_category
    @products = @products.where(category_id: params[:category_id])
  end

  def product_params
    params.require(:product).permit(:title, :description, { media: [] }, :subcategory_id, :category_id, :vendor_id, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight)
  end
end
