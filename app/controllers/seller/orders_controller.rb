class Seller::OrdersController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_order, only: [:show]

  # GET /vendor/orders
  def index
    @orders = current_vendor.orders
                            .includes(order_items: :ad)
                            .where(order_items: { ad_id: current_vendor.ads.ids })
                            .distinct
    render json: @orders, include: ['order_items.ad'], each_serializer: SellerOrderSerializer
  end

  # GET /vendor/orders/:id
  def show
    @order = current_vendor.orders.includes(order_items: :ad).find_by(id: params[:id])
    if @order
      render json: @order, include: ['order_items.ad'], serializer: SellerOrderSerializer
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end
  
  # PUT /vendor/orders/:id/status
  def update_status
    @order = current_vendor.orders.find_by(id: params[:id])
    
    unless @order
        return render json: { error: 'Order not found' }, status: :not_found
    end
    
    allowed_statuses = %w[Processing Dispatched On-Transit Delivered]

    if allowed_statuses.include?(params[:status])
        if @order.update(status: params[:status])
            render json: @order, include: ['order_items.ad'], serializer: SellerOrderSerializer
        else
            render json: { error: 'Failed to update order status' }, status: :unprocessable_entity
        end
    else
        render json: { error: 'Invalid status update' }, status: :forbidden
    end
  end

  private

  def set_order
    @order = current_vendor.orders.includes(order_items: :ad).find_by(id: params[:id])
    unless @order
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def authenticate_vendor
    @current_user = SellerAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_user
  end
end
