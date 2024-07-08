# app/controllers/vendor/products_controller.rb
module Vendor
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    before_action :authenticate_vendor

    def index
      @products = current_vendor.products
      render json: @products
    end

    def show
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
      if @product.update(product_params)
        render json: @product
      else
        render json: @product.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
    end

    private

    def set_product
      @product = current_vendor.products.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :description, :media, :category_id, :price, :quantity, :brand, :manufacturer, :package_dimensions, :package_weight)
    end

    def authenticate_vendor
      # Your authentication logic here
    end

    def current_vendor
      # Your logic to fetch current vendor here
    end
  end
end
