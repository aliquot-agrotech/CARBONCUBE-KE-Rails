class Purchaser::OrdersController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @orders = current_purchaser.orders.includes(order_items: [product: :vendor])
    render json: @orders, each_serializer: OrderSerializer
  end

  def show
    @order = current_purchaser.orders.includes(order_items: [product: :vendor]).find(params[:id])
    render json: @order, serializer: OrderSerializer
  end

  def create
    if params[:mpesa_transaction_code].blank?
      render json: { error: "Mpesa transaction code can't be blank" }, status: :unprocessable_entity
      return
    end
  
    ActiveRecord::Base.transaction do
      # Fetch cart items for the current purchaser
      cart_items = current_purchaser.cart_items
  
      # Calculate total item price separately
      item_total_price = cart_items.sum { |item| item.price * item.quantity }
  
      # Create the order with the provided details
      @order = current_purchaser.orders.new(
        status: 'Processing',
        mpesa_transaction_code: params[:mpesa_transaction_code],
        processing_fee: params[:processing_fee],  # New processing fee
        delivery_fee: params[:delivery_fee]       # New delivery fee
      )
  
      # Set the total amount including item total price and fees
      @order.total_amount = item_total_price + @order.processing_fee.to_f + @order.delivery_fee.to_f
  
      # Create order items and associate them with the order
      cart_items.each do |cart_item|
        @order.order_items.build(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.price,
          total_price: cart_item.price * cart_item.quantity
        )
      end
  
      # Identify vendors and create order_vendor records
      vendors = cart_items.map { |item| item.product.vendor }.uniq.compact
      vendors.each do |vendor|
        @order.order_vendors.build(vendor: vendor)
      end
  
      # Clear the cart after creating the order
      cart_items.destroy_all
  
      # Save the order and associated items
      @order.save!
    end
  
    render json: @order, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
  

  def update_status_to_delivered
    @order = Order.find(params[:id])

    if @order.update(params.require(:order).permit(:status))
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end
end
