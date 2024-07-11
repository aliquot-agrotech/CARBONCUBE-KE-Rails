class Vendor::OrdersController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_order, only: [:show, :update, :destroy, :update_status]

  # GET /vendor/orders
  def index
    @orders = current_vendor.orders.includes(:order_items).where(order_items: { product_id: current_vendor.products.ids })
    render json: @orders, include: ['order_items.product']
  end

  # GET /vendor/orders/:id
  def show
    render json: @order, include: ['order_items.product']
  end

  # PATCH/PUT /vendor/orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendor/orders/:id/update_status
  def update_status
    if @order.update(status: params[:status])
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vendor/orders/:id
  def destroy
    @order.destroy
    head :no_content
  end

  # GET /vendor/invoices
  def invoices
    @invoices = current_vendor.orders.select(:id, :total_amount, :status, :created_at)
    render json: @invoices
  end

  private

  def set_order
    @order = current_vendor.orders.includes(:order_items).find_by(id: params[:id])
    unless @order
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def order_params
    params.require(:order).permit(:status, :is_sent_out, :is_processing, :is_delivered)
  end

  def authenticate_vendor
    @current_user = AuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_user
  end
end
