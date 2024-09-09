# app/controllers/purchaser/cart_items_controller.rb

class Purchaser::CartItemsController < ApplicationController
  before_action :authenticate_purchaser

  # GET /purchaser/cart_items
  def index
    @cart_items = current_purchaser.cart_items.includes(:product)
    total_cart_price = @cart_items.sum(&:total_price)
    render json: { cart_items: @cart_items, total_cart_price: total_cart_price }, include: ['product']
  end

  # POST /purchaser/cart_items
  def create
    @cart_item = current_purchaser.cart_items.build(cart_item_params)

    if @cart_item.save
      update_cart_total_price
      render json: @cart_item, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  # Purchaser::CartItemsController
  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      render json: cart_item, status: :ok
    else
      render json: { error: 'Failed to update item' }, status: :unprocessable_entity
    end
  end


  # DELETE /purchaser/cart_items/:id
  def destroy
    @cart_item = current_purchaser.cart_items.find(params[:id])
    @cart_item.destroy
    update_cart_total_price
    head :no_content
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end

  def update_cart_total_price
    total_price = current_purchaser.cart_items.sum(&:total_price)
    current_purchaser.update(cart_total_price: total_price)
  end
end
