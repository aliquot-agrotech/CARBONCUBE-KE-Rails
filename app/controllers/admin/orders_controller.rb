class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_order, only: [:show, :update_status, :destroy]

  # GET /admin/orders
  def index
    if params[:search_query].present?
      @orders = Order.joins(order_items: { product: :vendor }, purchaser: {})
                     .where("vendors.phone_number = :query OR purchasers.phone_number = :query OR orders.id = :query", query: params[:search_query])
                     .includes(:purchaser, order_items: { product: :vendor })
    else
      @orders = Order.includes(:purchaser, order_items: { product: :vendor }).all
    end

    render json: @orders.map { |order| serialized_order(order) }
  end

  # GET /admin/orders/:id
  def show
    render json: serialized_order(@order)
  end

  # PUT /admin/orders/:id/update-status
  def update_status
    if @order.update(status: params[:status])
      render json: serialized_order(@order)
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /admin/orders/:id
  def destroy
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:purchaser_id, :status, :total_amount)
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def serialized_order(order)
    {
      id: order.id,
      purchaser: {
        id: order.purchaser.id,
        fullname: order.purchaser.fullname,
        phone_number: order.purchaser.phone_number
      },
      order_items: order.order_items.map do |item|
        {
          id: item.id,
          quantity: item.quantity,
          product: {
            id: item.product.id,
            title: item.product.title,
            price: item.product.price
          },
          vendor: {
            id: item.product.vendor.id,
            fullname: item.product.vendor.fullname
          }
        }
      end,
      status: order.status,
      total_amount: order.order_items.sum { |item| item.quantity * item.product.price },
      processing_fee: order.processing_fee,
      delivery_fee: order.delivery_fee,
      mpesa_transaction_code: order.mpesa_transaction_code,
      order_date: order.created_at.strftime('%Y-%m-%d'),
      created_at: order.created_at,
      updated_at: order.updated_at
    }
  end
end
