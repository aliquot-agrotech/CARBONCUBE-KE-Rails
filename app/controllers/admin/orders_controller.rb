# app/controllers/orders_controller.rb

class Admin::OrdersController < ApplicationController
    before_action :set_order, only: [:show, :update, :destroy]
  
    # GET /orders
    def index
      orders = Order.includes(:order_items, :purchaser).all
      render json: orders, status: :ok
    end
  
    # GET /orders/1
    def show
      render json: @order
    end
  
    # POST /orders
    def create
      @order = Order.new(order_params)
  
      if @order.save
        render json: @order, status: :created, location: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /orders/1
    def update
      if @order.update(order_params)
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /orders/1
    def destroy
      @order.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_order
        @order = Order.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def order_params
        params.require(:order).permit(:purchaser_id, :status, :total_amount, :is_sent_out, :is_processing, :is_delivered, 
                                      order_items_attributes: [:id, :product_id, :quantity, :_destroy], 
                                      order_vendors_attributes: [:id, :vendor_id, :_destroy])
      end
  end
  
  