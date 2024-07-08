module Vendor
    class AnalyticsController < ApplicationController
      def index
        @analytics = {
          revenue: current_vendor.orders.sum(:total_amount),
          products_in_stock: current_vendor.products.sum(:quantity),
          products_sold: current_vendor.order_items.sum(:quantity),
          total_orders: current_vendor.orders.count,
          invoices: current_vendor.orders.pluck(:id, :total_amount, :status, :created_at)
        }
  
        render json: @analytics
      end
    end
  end
  