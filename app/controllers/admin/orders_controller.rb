class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_order, only: [:show, :update_status, :destroy]

  # GET /admin/orders
  def index
    if params[:search_query].present?
      @orders = Order.joins(:purchaser)
                     .where("vendors.phone_number = :query OR purchasers.phone_number = :query OR orders.id = :query", query: params[:search_query])
                     .includes(:purchaser, order_items: { product: :vendor })
    else
      @orders = Order.includes(:purchaser, order_items: { product: :vendor }).all
    end

    render json: @orders, each_serializer: OrderSerializer
  end

  # GET /admin/orders/:id
  def show
    render json: @order, serializer: OrderSerializer
  end

  # PUT /admin/orders/:id/update-status
  def update_status
    if @order.update(status: params[:status])
      render json: @order, serializer: OrderSerializer
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

  def current_admin
    @current_user
  end
end
