module Vendor
  class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :update, :destroy, :update_status]

    # GET /vendor/orders
    def index
      @orders = current_vendor.orders
      render json: @orders
    end

    # GET /vendor/orders/:id
    def show
      render json: @order
    end

    # PATCH/PUT /vendor/orders/:id
    def update
      if @order.update(order_params)
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /vendor/orders/:id/update_status
    def update_status
      if @order.update(status: params[:status])
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end

    # GET /vendor/invoices
    def invoices
      @invoices = current_vendor.orders.select(:id, :total_amount, :status, :created_at)
      render json: @invoices
    end

    private

    def set_order
      @order = current_vendor.orders.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status, :is_sent_out, :is_processing, :is_delivered)
    end
  end
end
