# app/controllers/purchaser/profiles_controller.rb
class Purchaser::ProfilesController < ApplicationController
  before_action :authenticate_purchaser

  # GET /purchaser/profile
  def show
    render json: current_purchaser
  end

  # PATCH/PUT /purchaser/profile
  def update
    if current_purchaser.update(purchaser_params)
      render json: current_purchaser
    else
      render json: current_purchaser.errors, status: :unprocessable_entity
    end
  end

  # POST /purchaser/change-password
  def change_password
    # Check if the current password is correct
    if current_purchaser.authenticate(params[:currentPassword])
      # Check if new password matches confirmation
      if params[:newPassword] == params[:confirmPassword]
        # Update the password
        if current_purchaser.update(password: params[:newPassword])
          render json: { message: 'Password updated successfully' }, status: :ok
        else
          render json: { errors: current_purchaser.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'New password and confirmation do not match' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end
  

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end

  # Updated purchaser_params to permit top-level parameters
  def purchaser_params
    params.permit(:fullname, :username, :phone_number, :email, :location, :zipcode, :fullname, :location, :gender, :city, :birthdate)
  end
end
