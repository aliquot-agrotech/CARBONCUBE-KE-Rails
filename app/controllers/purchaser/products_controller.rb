class Purchaser::ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
  
    # GET /products
    def index
        @products = Product.all
        render json: @products
    end
  
    # GET /products/:id
    def show
        render json: @product
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_product
        @product = Product.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def product_params
        params.require(:product).permit(:title, :description, :media[], :category_id, :vendor_id, :price, :quantity, :brand, :manufacturer, :package_length, :package_width, :package_height, :package_weight)
    end
end
  