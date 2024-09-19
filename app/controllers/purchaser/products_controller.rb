# app/controllers/purchaser/products_controller.rb
class Purchaser::ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /purchaser/products
  def index
    @products = Product.joins(:vendor)
                      .where(vendors: { blocked: false })
                      .where(flagged: false) # Exclude flagged products
    filter_by_category if params[:category_id].present?
    filter_by_subcategory if params[:subcategory_id].present? # New subcategory filtering
    render json: @products, each_serializer: ProductSerializer
  end

  # GET /purchaser/products/:id
  def show
    @product = Product.find(params[:id])
    render json: @product, serializer: ProductSerializer
  end
  

  # GET /purchaser/products/search
  def search
    query = params[:query].to_s.strip
    query_words = query.split(/\s+/)

    @products = Product.joins(:vendor, :category, :subcategory)
                      .where(vendors: { blocked: false })
                      .where(flagged: false)  # Exclude flagged products
                      
    query_words.each do |word|
      @products = @products.where('products.title ILIKE :word OR products.description ILIKE :word OR categories.name ILIKE :word OR subcategories.name ILIKE :word', 
                                  word: "%#{word}%") # Include subcategory in search
    end

    filter_by_category if params[:category_id].present?
    filter_by_subcategory if params[:subcategory_id].present? # Include subcategory filtering in search

    @products = @products.distinct

    render json: @products
  end

  # GET /purchaser/products/:id/related
  def related
    product = Product.find(params[:id])
    
    # Find products from the same subcategory
    related_products = Product.where(subcategory: product.subcategory)

    # Find products that share words in the title
    title_words = product.title.split(' ')
    related_by_title = Product.where('title ILIKE ANY (array[?])', title_words.map { |word| "%#{word}%" })

    # Combine results, excluding the original product
    related_products = related_products.or(related_by_title).where.not(id: product.id).distinct

    render json: related_products
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

  def filter_by_subcategory
    @products = @products.where(subcategory_id: params[:subcategory_id])
  end

  def product_params
    params.require(:product).permit(:title, :description, { media: [] }, :subcategory_id, :category_id, :vendor_id, :price, :quantity, :brand, :manufacturer, :item_length, :item_width, :item_height, :item_weight)
  end
end
