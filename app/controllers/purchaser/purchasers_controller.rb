class Purchaser::PurchasersController < ApplicationController
  before_action :set_purchaser, only: [:show, :update]
  before_action :authenticate_purchaser, only: [:identify, :show, :update]
  before_action :set_default_format

  # GET /purchaser/identify
  def identify
    render json: { purchaser_id: current_purchaser.id }
  end

  # GET /purchasers/:id
  def show
    render json: current_purchaser
  end

  def create
    logger.debug "Purchaser Params Received: #{purchaser_params.inspect}"
    
    @purchaser = Purchaser.new(purchaser_params)
    
    if Purchaser.exists?(email: @purchaser.email)
      render json: { errors: ['Email has already been taken'] }, status: :unprocessable_entity
    elsif Purchaser.exists?(username: @purchaser.username)
      render json: { errors: ['Username has already been taken'] }, status: :unprocessable_entity
    elsif @purchaser.save
      token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: 'Purchaser')
      render json: { token: token, purchaser: @purchaser }, status: :created
    else
      logger.debug "Purchaser Errors: #{@purchaser.errors.full_messages}"
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

  def purchaser_params
    permitted = params.require(:purchaser).permit(
      :fullname, :username, :email, :phone_number, :password, 
      :password_confirmation, :age_group_id, :zipcode, :city, :gender, 
      :location, :income_id, :sector_id, :education_id, :employment_id,
      :county_id, :sub_county_id
    )

    # Convert blank string values to nil
    permitted.each { |key, value| permitted[key] = nil if value == "" }

    permitted
  end


  def set_default_format
    request.format = :json unless params[:format]
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
