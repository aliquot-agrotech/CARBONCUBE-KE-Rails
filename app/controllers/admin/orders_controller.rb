# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_order, only: [:show, :update_status_to_on_transit, :destroy]

  def index
    @orders = Order.includes(:purchaser, order_items: { product: :vendor }).all
    render json: @orders.as_json(
      include: { 
        purchaser: {}, 
        order_items: { 
          include: { 
            product: { include: :vendor } 
          } 
        }
      },
      methods: [:order_date, :total_price]
    )
  end

  def show
    render json: @order.as_json(
      include: { 
        purchaser: {}, 
        order_items: { 
          include: { 
            product: { include: :vendor } 
          } 
        }
      },
      methods: [:order_date, :total_price]
    )
  end

  # PUT /admin/orders/:id/on-transit
  def update_status_to_on_transit
    if @order.update(status: params[:status])
      render json: @order
    else
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

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
