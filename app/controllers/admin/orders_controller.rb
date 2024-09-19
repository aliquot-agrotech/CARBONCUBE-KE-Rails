class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_order, only: [:show, :update_status_to_on_transit, :destroy]

  # app/controllers/admin/orders_controller.rb
  def index
    if params[:search_query].present?
      @orders = Order.joins(:purchaser)
                    .where("vendors.phone_number = :query OR purchasers.phone_number = :query OR orders.id = :query", query: params[:search_query])
                    .includes(:purchaser, order_items: { product: :vendor })
    else
      @orders = Order.includes(:purchaser, order_items: { product: :vendor }).all
    end
  
    render json: @orders.as_json(
      include: {
        purchaser: { only: [:fullname] },
        order_items: {
          include: {
            product: {
              include: { vendor: { only: [:fullname] } }
            }
          }
        }
      },
      methods: [:order_date, :total_price]
    )
  end
  
  def show
    render json: @order.as_json(
      include: {
        purchaser: { only: [:fullname] },
        order_items: {
          include: {
            product: {
              include: { vendor: { only: [:fullname] } }
            }
          }
        }
      },
      methods: [:order_date, :total_price]
    )
  end

  # PUT /admin/orders/:id/on-transit
  def update_status_to_on_transit
    if @order.update(status: params[:status])
      render json: @order.as_json(
        include: {
          purchaser: { only: [:fullname] },
          order_items: {
            include: {
              product: {
                include: { vendor: { only: [:fullname] } }
              }
            }
          }
        },
        methods: [:order_date, :total_price]
      )
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
