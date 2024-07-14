class Purchaser::ProductsController < ApplicationController
    before_action :set_product, only: [:show]
  
    # GET /purchaser/products
    def index
      @products = Product.all
      render json: @products
    end
  
    # GET /purchaser/products/:id
    def show
      render json: @product
    end
  
    private
  
    def set_product
      @product = Product.find(params[:id])
    end
  
    def product_params
      params.require(:product).permit(:title, :description, {media: []}, :category_id, :vendor_id, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight)
    end
  end
  