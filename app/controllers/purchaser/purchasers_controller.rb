class Purchaser::PurchasersController < ApplicationController
  before_action :set_purchaser, only: [:show, :update]
  before_action :authenticate_purchaser, only: [:identify, :show, :update]

  # GET /purchaser/identify
  def identify
    render json: { purchaser_id: current_purchaser.id }
  end

  # GET /purchasers/:id
  def show
    render json: current_purchaser
  end

  # POST /purchasers
  def create
    @purchaser = Purchaser.new(purchaser_params)
    
    if @purchaser.save
      token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: 'Purchaser')
      render json: { token: token, purchaser: @purchaser }, status: :created
    else
      render json: { errors: @purchaser.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /purchasers/:id
  def update
    if current_purchaser.update(purchaser_params)
      render json: current_purchaser
    else
      render json: current_purchaser.errors, status: :unprocessable_entity
    end
  end

  # DELETE /purchasers/:id
  def destroy
    current_purchaser.destroy
    head :no_content
  end

  private

  def set_purchaser
    @purchaser = Purchaser.find(params[:id])
  end
  end

  def purchaser_params
    params.require(:purchaser).permit(:fullname, :username, :phone_number, :email, :location, :password, :password_confirmation)
  end

  def authenticate_purchaser
    @current_purchaser = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_purchaser
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_purchaser
  end
end
