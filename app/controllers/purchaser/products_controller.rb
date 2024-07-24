# app/controllers/purchaser/products_controller.rb
class Purchaser::ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /purchaser/products
  def index
    @products = Product.joins(:vendor).where(vendors: { blocked: false })
    render json: @products
  end

  # GET /purchaser/products/:id
  def show
    render json: @product
  end

  # GET /purchaser/products/search
  def search
    if params[:query].present?
      @products = Product.joins(:vendor)
                         .where(vendors: { blocked: false })
                         .search_by_title_and_description(params[:query])
    else
      @products = Product.joins(:vendor)
                         .where(vendors: { blocked: false })
    end

    render json: @products
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  def product_params
    params.require(:product).permit(:title, :description, { media: [] }, :category_id, :vendor_id, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight)
  end
end
