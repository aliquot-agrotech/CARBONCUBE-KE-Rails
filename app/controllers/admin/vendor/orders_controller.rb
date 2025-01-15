class Admin::Vendor::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor

  # GET /admin/vendors/:vendor_id/orders
  def index_for_vendor
    # Get all orders that have order_items related to the vendor's ads
    orders = @vendor.orders.includes(order_items: :ad, purchaser: :orders).where(order_items: { ad_id: @vendor.ads.pluck(:id) })

    # Prepare the response with filtered orders, including the purchaser details
    filtered_orders = orders.map do |order|
      {
        order: order.as_json(only: [:id, :status, :created_at, :updated_at, :mpesa_transaction_code]),
        purchaser: order.purchaser.as_json(only: [:id, :fullname, :email, :phone_number]),
        order_items: order.order_items.select { |item| @vendor.ads.exists?(item.ad_id) }.as_json(include: { ad: { only: [:id, :title, :price] } })
      }
    end

    render json: filtered_orders
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
