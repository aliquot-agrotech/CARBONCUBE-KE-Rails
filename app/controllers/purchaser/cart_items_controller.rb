class Purchaser::CartItemsController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @cart_items = current_purchaser.cart_items.includes(:product)
    render json: @cart_items, include: ['product']
  end

  def create
    @cart_item = current_purchaser.cart_items.build(cart_item_params)

    if @cart_item.save
      render json: @cart_item, status: :created
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def update
    @cart_item = current_purchaser.cart_items.find(params[:id])

    if @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @cart_item = current_purchaser.cart_items.find(params[:id])
    @cart_item.destroy
    head :no_content
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def authenticate_purchaser
    @current_user = AuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end
end
