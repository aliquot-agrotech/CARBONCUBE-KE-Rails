class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def login
    if params[:email].present?
      # Check for email login for all user types
      @user = Purchaser.find_by(email: params[:email]) ||
              Vendor.find_by(email: params[:email]) ||
              Admin.find_by(email: params[:email]) ||
              Rider.find_by(email: params[:email])
    elsif params[:phone_number].present? || params[:id_number].present?
      # Check for phone number or ID number login for riders only
      @user = Rider.find_by(phone_number: params[:phone_number]) ||
              Rider.find_by(id_number: params[:id_number])
    end

    # Authenticate user and return token if valid
    if @user&.authenticate(params[:password])
      user_response = {
        id: @user.id,
        email: @user.email,
        role: determine_role(@user)
      }
      # Add phone_number and id_number for riders
      user_response[:phone_number] = @user.phone_number if @user.is_a?(Rider)
      user_response[:id_number] = @user.id_number if @user.is_a?(Rider)

      token = JsonWebToken.encode(user_id: @user.id, role: determine_role(@user))
      render json: { token: token, user: user_response }, status: :ok
    else
      render json: { errors: ['Invalid login credentials'] }, status: :unauthorized
    end
  end

  private

  def determine_role(user)
    case user
    when Purchaser then 'purchaser'
    when Vendor then 'vendor'
    when Admin then 'admin'
    when Rider then 'rider'
    else 'unknown'
    end
  end
end
