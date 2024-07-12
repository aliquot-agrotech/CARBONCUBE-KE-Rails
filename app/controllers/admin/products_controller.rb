# app/controllers/vendor/products_controller.rb
class Admin::ProductsController < ApplicationController 
    before_action :authenticate_admin
  
    def index
      @products = current_vendor.products
      render json: @products
    end
  
    def show
      @product = current_vendor.products.find(params[:id])
      render json: @product
    end
  
    def create
      @product = current_vendor.products.build(product_params)
      if @product.save
        render json: @product, status: :created
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @product = current_vendor.products.find(params[:id])
      if @product.update(product_params)
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @product = current_vendor.products.find(params[:id])
      @product.destroy
      head :no_content
    end
  
    private
  
    def product_params
      params.require(:product).permit(:title, :description, :price, :quantity, :category_id, :brand, :manufacturer, :package_dimensions, :package_weight)
    end
  
    def authenticate_admin
      @current_user = AdminAuthorizeApiRequest.new(request.headers).result
      unless @current_user && @current_user.is_a?(Admin)
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  
    def current_admin
      @current_user
    end
    
  end
  