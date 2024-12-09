# app/controllers/purchaser/wish_lists_controller.rb
class Purchaser::WishListsController < ApplicationController
  before_action :authenticate_purchaser

  # GET /purchaser/wish_lists
  def index
    @wish_lists = current_purchaser.wish_lists.includes(:product)
    
    render json: @wish_lists.as_json(include: {
      product: {
        only: [:id, :title, :price, :rating],
        methods: [:first_media_url] # Include a method to get the first media URL
      }
    })
  end

  # POST /purchaser/wish_lists
  def create
    product = Product.find(params[:product_id])
    current_purchaser.wish_list_product(product)
    render json: { message: 'Product wishlisted successfully' }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  # DELETE /purchaser/wish_lists/:id
  def destroy
    product = Product.find(params[:id])
    if current_purchaser.unwish_list_product(product)
      render json: { message: 'Wish list removed successfully' }, status: :ok
    else
      render json: { error: 'Wish list not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  # POST /purchaser/wish_lists/:id/add_to_cart
  def add_to_cart
    product = Product.find(params[:id])
    cart_item = CartItem.new(purchaser: current_purchaser, product: product)

    if cart_item.save
      render json: { message: 'Product added to cart' }, status: :created
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user.is_a?(Purchaser)
  end

  def current_purchaser
    @current_user
  end
end
