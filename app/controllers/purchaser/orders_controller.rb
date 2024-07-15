class Purchaser::OrdersController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @orders = current_purchaser.orders
    render json: @orders
  end

  def show
    @order = current_purchaser.orders.find(params[:id])
    render json: @order
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
  
  # PUT /purchaser/orders/:id/deliver
  def update_status_to_delivered
    @order = current_purchaser.orders.find(params[:id])

    if @order.update(status: 'delivered')
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
