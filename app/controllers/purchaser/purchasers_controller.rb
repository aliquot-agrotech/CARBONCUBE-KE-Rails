class Purchaser::PurchasersController < ApplicationController
  before_action :set_purchaser, only: [:show, :update]
  before_action :authenticate_purchaser, only: [:identify, :show, :update, :destroy]
  before_action :set_default_format

  # GET /purchaser/identify
  def identify
    render json: { purchaser_id: current_purchaser.id }
  end

  # GET /purchasers/:id
  def show
    render json: current_purchaser
  end

  # POST /purchasers/signup
  def create
    logger.debug "Purchaser Params Received: #{purchaser_params.inspect}"

    purchaser_email = purchaser_params[:email].downcase.strip

    if Vendor.exists?(email: purchaser_email)
      render json: { errors: ['Email is already in use by a vendor'] }, status: :unprocessable_entity
    elsif Purchaser.exists?(email: purchaser_email)
      render json: { errors: ['Email has already been taken'] }, status: :unprocessable_entity
    elsif Purchaser.exists?(username: purchaser_params[:username])
      render json: { errors: ['Username has already been taken'] }, status: :unprocessable_entity
    else
      @purchaser = Purchaser.new(purchaser_params)

      if @purchaser.save
        token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: 'Purchaser')
        render json: { token: token, purchaser: @purchaser }, status: :created
      else
        logger.debug "Purchaser Errors: #{@purchaser.errors.full_messages}"
        render json: { errors: @purchaser.errors.full_messages }, status: :unprocessable_entity
      end
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
    if current_purchaser.nil?
      Rails.logger.error("Current purchaser is nil during account deletion.")
      render json: { error: 'Not Authorized' }, status: :unauthorized
      return
    end

    if current_purchaser.update(deleted: true)
      head :no_content
    else
      render json: { error: 'Failed to delete account' }, status: :unprocessable_entity
    end
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

    if @current_purchaser.nil?
      render json: { error: 'Not Authorized' }, status: :unauthorized
    elsif @current_purchaser.deleted?
      render json: { error: 'Account has been deleted' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_purchaser
  end
end
