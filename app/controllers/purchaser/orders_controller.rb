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

      # Create the order with the provided details
      @order = current_purchaser.orders.create!(
        status: 'Processing',
        mpesa_transaction_code: params[:mpesa_transaction_code],
        total_amount: params[:total_amount] # Total amount should be passed from frontend
      )

      # Create order items and associate them with the order
      cart_items.each do |cart_item|
        @order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.price,
          total_price: cart_item.price * cart_item.quantity
        )
      end

      # Identify vendors and create order_vendor records
      vendors = cart_items.map { |item| item.product.vendor }.uniq.compact
      vendors.each do |vendor|
        @order.order_vendors.create!(vendor: vendor)
      end

      # Clear the cart after creating the order
      cart_items.destroy_all
    end

    render json: @order, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
  
  
  def update_status_to_delivered
    @order = Order.find(params[:id])
    
    if @order.update(params.require(:order).permit(:status))
      create_notification_for_order_status(@order)
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def create_notification_for_order_status(order)
    Notification.create!(
      order_id: order.id,
      status: order.status,
      notifiable: order.purchaser # or the user related to the order
    )
    
    NotificationsChannel.broadcast_to(
      order.purchaser,
      notification: NotificationSerializer.new(notification).as_json
    )
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
end
