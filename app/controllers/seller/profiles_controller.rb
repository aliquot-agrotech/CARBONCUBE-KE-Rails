class Seller::ProfilesController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_vendor, only: [:show, :update]

  # GET /vendor/profile
  def show
    render json: @vendor
  end

  # PATCH/PUT /vendor/profile
  def update
    if @vendor.update(vendor_params)
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # POST /vendor/change-password
  def change_password
    # Check if the current password is correct
    if current_vendor.authenticate(params[:currentPassword])
      # Check if new password matches confirmation
      if params[:newPassword] == params[:confirmPassword]
        # Update the password
        if current_vendor.update(password: params[:newPassword])
          render json: { message: 'Password updated successfully' }, status: :ok
        else
          render json: { errors: current_vendor.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'New password and confirmation do not match' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end

  private

  def set_vendor
    @vendor = current_vendor
  end

  def vendor_params
    params.permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, :gender, :city, :birthdate, :zipcode, :username)
  end

  def authenticate_vendor
    @current_vendor = SellerAuthorizeApiRequest.new(request.headers).result
    unless @current_vendor && @current_vendor.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_vendor
  end
end
