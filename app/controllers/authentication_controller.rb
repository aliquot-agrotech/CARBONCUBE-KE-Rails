class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def login
    identifier = params[:identifier]  # Use unified identifier param
    @user = find_user_by_identifier(identifier)

    if @user&.authenticate(params[:password])
      user_response = {
        id: @user.id,
        email: @user.email,
        role: determine_role(@user)
      }
      user_response[:phone_number] = @user.phone_number if @user.is_a?(Rider)
      user_response[:id_number] = @user.id_number if @user.is_a?(Rider)

      token = JsonWebToken.encode(user_id: @user.id, role: determine_role(@user))
      render json: { token: token, user: user_response }, status: :ok
    else
      render json: { errors: ['Invalid login credentials'] }, status: :unauthorized
    end
  end

  private

  def find_user_by_identifier(identifier)
    if identifier.include?('@')
      # Assume it's an email if it contains '@'
      Purchaser.find_by(email: identifier) ||
      Vendor.find_by(email: identifier) ||
      Admin.find_by(email: identifier) ||
      Rider.find_by(email: identifier)
    elsif identifier.match?(/\A\d{10}\z/)
      # Assume phone number if it’s 10 digits
      Rider.find_by(phone_number: identifier)
    else
      # Otherwise, assume it’s an ID number
      Rider.find_by(id_number: identifier)
    end
  end

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
