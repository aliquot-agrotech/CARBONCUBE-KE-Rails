# app/controllers/vendor/products_controller.rb

class Vendor::ProductsController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_vendor

  def index
    @products = @vendor.products
    render json: @products, status: :ok
  end

  def show
    @product = @vendor.products.find(params[:id])
    render json: @product
  end

  def create
    @product = @vendor.products.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    @product = @vendor.products.find(params[:id])

    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product = @vendor.products.find(params[:id])
    @product.destroy
  end

  private

  def set_vendor
    @vendor = current_vendor
  end

  def product_params
    params.require(:product).permit(:title, :description, :media, :category_id, :price, :quantity, :brand, :manufacturer, :package_dimensions, :package_weight)
  end

  def authenticate_vendor
    @current_user = AuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: 401
    end
  end

  def current_vendor
    @current_user
  end
end
