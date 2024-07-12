# app/controllers/purchaser/orders_controller.rb
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
    @order = current_purchaser.orders.build(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def checkout
    @order = current_purchaser.orders.find(params[:id])
    mpesa_code = params[:mpesa_code]

    if @order.update(mpesa_transaction_code: mpesa_code)
      render json: { message: 'Checkout completed and MPESA transaction code saved successfully' }, status: :ok
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_status
    @order = current_purchaser.orders.find(params[:id])

    if params[:status] == 'delivered' && @order.update(status: 'delivered')
      render json: @order
    else
      render json: { errors: 'Only the status can be set to delivered by the purchaser' }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:product_id, :quantity])
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
