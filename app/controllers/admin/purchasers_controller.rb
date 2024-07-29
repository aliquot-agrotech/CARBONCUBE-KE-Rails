class Admin::PurchasersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_purchaser, only: [:show, :update, :destroy]

  def index
    @purchasers = Purchaser.all
    render json: @purchasers
  end

  def show
    purchaser = Purchaser.includes(orders: { order_items: :product }).find(params[:id])
    render json: purchaser.to_json(
      include: {
        orders: {
          include: {
            order_items: {
              include: :product
            }
          }
        }
      }
    )
  end
  

  def create
    @purchaser = Purchaser.new(purchaser_params)
    if @purchaser.save
      render json: @purchaser, status: :created
    else
      render json: @purchaser.errors, status: :unprocessable_entity
    end
  end

  def update
    if @purchaser.update(purchaser_params)
      render json: @purchaser
    else
      render json: @purchaser.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @purchaser.destroy
    head :no_content
  end

  private

  def set_purchaser
    @purchaser = Purchaser.find(params[:id])
  end

  def purchaser_params
    params.require(:purchaser).permit(:fullname, :username, :phone_number, :email, :location, :password)
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
