class Vendor::OrdersController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_order, only: [:show]

  # GET /vendor/orders
  def index
    @orders = current_vendor.orders
                            .includes(order_items: :product)
                            .where(order_items: { product_id: current_vendor.products.ids })
                            .distinct
    render json: @orders, include: ['order_items.product'], each_serializer: VendorOrderSerializer
  end

  # GET /vendor/orders/:id
  def show
    @order = current_vendor.orders.includes(order_items: :product).find_by(id: params[:id])
    if @order
      render json: @order, include: ['order_items.product'], serializer: VendorOrderSerializer
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end
  
  # PUT /vendor/orders/:id/status
  def update_status
    @order = current_vendor.orders.find_by(id: params[:id])
    
    unless @order
        return render json: { error: 'Order not found' }, status: :not_found
    end
    
    allowed_statuses = %w[Processing Dispatched On-Transit Delivered]

    if allowed_statuses.include?(params[:status])
        if @order.update(status: params[:status])

            # Create a notification for the vendor
            Notification.create!(
                order_id: @order.id,
                status: params[:status],
                notifiable: current_vendor
            )

            # Create a notification for the purchaser
            Notification.create!(
                order_id: @order.id,
                status: params[:status],
                notifiable: @order.purchaser # assuming `purchaser` is an association on the Order model
            )

            # Create a notification for the admin
            admin = Admin.first # assuming you have a way to identify which admin should be notified
            Notification.create!(
                order_id: @order.id,
                status: params[:status],
                notifiable: admin
            )

            render json: @order, include: ['order_items.product'], serializer: VendorOrderSerializer
        else
            render json: { error: 'Failed to update order status' }, status: :unprocessable_entity
        end
    else
        render json: { error: 'Invalid status update' }, status: :forbidden
    end
  end




  private

  def set_order
    @order = current_vendor.orders.includes(order_items: :product).find_by(id: params[:id])
    unless @order
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_user
  end
end
