# app/controllers/orders_controller.rb
class Purchaser::OrdersController < ApplicationController
  before_action :authenticate_purchaser

  # GET /orders
  def index
    @orders = current_purchaser.orders.includes(:order_items, :vendors)
    render json: @orders, include: ['order_items', 'vendors'], status: :ok
  end

  # GET /orders/:id
  def show
    @order = current_purchaser.orders.find_by(id: params[:id])
    if @order
      render json: @order, include: ['order_items', 'vendors'], status: :ok
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  # POST /orders
  def create
    @order = current_purchaser.orders.new(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /orders/:id/checkout
  def checkout
    @order = current_purchaser.orders.find_by(id: params[:id])
    mpesa_code = params[:mpesa_code]

    if @order.nil?
      render json: { error: 'Order not found' }, status: :not_found
      return
    end

    # Create invoice for the order
    invoice = Invoice.new(order: @order, mpesa_transaction_code: mpesa_code, total_amount: @order.total_amount)

    if invoice.save
      render json: { message: 'Invoice created successfully' }, status: :created
    else
      render json: { errors: invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity])
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
