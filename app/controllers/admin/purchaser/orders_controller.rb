class Admin::Purchaser::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_purchaser

  # GET /admin/purchasers/:purchaser_id/orders
  def index_for_purchaser
    @orders = @purchaser.orders.includes(order_items: { product: :vendor })

    # Calculate total amount for each order
    orders_with_totals = @orders.map do |order|
      total_amount = order.order_items.sum { |item| item.total_price.to_f }
      order.as_json(include: {
        order_items: {
          include: {
            product: {
              only: [:title],
              include: { vendor: { only: [:fullname] } }
            }
          }
        }
      }).merge("total_amount" => total_amount)
    end

    render json: orders_with_totals
  end

  private

  def set_purchaser
    @purchaser = Purchaser.find(params[:purchaser_id])
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end
end
