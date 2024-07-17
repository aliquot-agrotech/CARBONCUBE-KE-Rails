class Vendor::OrdersController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_order, only: [:show, :destroy]

  # GET /vendor/orders
  def index
    @orders = current_vendor.orders.includes(order_items: :product).where(order_items: { product_id: current_vendor.products.ids }).distinct
    render json: @orders, include: ['order_items.product'], except: [:mpesa_transaction_code], each_serializer: VendorOrderSerializer
  end

  # GET /vendor/orders/:id
  def show
    render json: @order, include: ['order_items.product'], except: [:mpesa_transaction_code], serializer: VendorOrderSerializer
  end



  # DELETE /vendor/orders/:id
  def destroy
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = current_vendor.orders.includes(order_items: :product).find_by(id: params[:id])
    unless @order
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_user
  end
end
