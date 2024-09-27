class Vendor::ProductsController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    @products = current_vendor.products.includes(:category, :reviews) # Ensure category and reviews are included
    render json: @products.to_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def show
    render json: @product.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def create
    # Build the product with the permitted parameters
    @product = current_vendor.products.build(product_params)
  
    # Save the product and return appropriate JSON response
    if @product.save
      render json: @product.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating]), status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end
  


  def update
    if params[:product][:media].present?
      media = params[:product][:media].is_a?(Array) ? params[:product][:media] : [params[:product][:media]]
      @product.media = media
    end
  
    if @product.update(product_params)
      render json: @product.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end
  
  


  def destroy
    @product.destroy
    head :no_content
  end

  private

  # app/controllers/vendor/products_controller.rb
  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end


  def current_vendor
    @current_user
  end

  def set_product
    @vendor = current_vendor
    if @vendor.nil?
      render json: { error: 'Vendor not found' }, status: :not_found
      return
    end

    @product = @vendor.products.find_by(id: params[:id])
    unless @product
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def product_params
    params.require(:product).permit(
      :title, :description, :category_id, :subcategory_id, :price, 
      :quantity, :brand, :manufacturer, :item_length, :item_width, 
      :item_height, :item_weight, :weight_unit, :flagged,
      media: [] # Allow an array of media
    )
  end
end
