class Admin::Vendors::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor

  # GET /admin/vendors/:vendor_id/orders
  def index_for_vendor
    # Get all orders that have order_items related to the vendor's products
    orders = @vendor.orders.includes(order_items: :product).where(order_items: { product_id: @vendor.products.pluck(:id) })

    # Filter the order_items to include only those related to the specific vendor
    filtered_orders = orders.map do |order|
      {
        order: order.as_json(except: [:mpesa_transaction_code]),
        order_items: order.order_items.select { |item| @vendor.products.exists?(item.product_id) }.as_json(include: :product)
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
