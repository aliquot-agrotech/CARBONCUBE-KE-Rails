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
      @order = current_purchaser.orders.create!(
        status: 'processing',
        mpesa_transaction_code: params[:mpesa_transaction_code]
      )

      current_purchaser.cart_items.each do |cart_item|
        @order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.total_price
        )
        cart_item.destroy
      end
    end

    render json: @order, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
  
  def update_status_to_delivered
    @order = Order.find(params[:id])
    
    if @order.update(order_params)
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
