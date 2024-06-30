class AuthenticationController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:login]

    def login
        @user = Purchaser.find_by(email: params[:email]) || Vendor.find_by(email: params[:email]) || Admin.find_by(email: params[:email])
        
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id, role: determine_role(@user))
            render json: { token: token, user: @user }, status: :ok
        else
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end

    private

    def determine_role(user)
        if user.is_a?(Purchaser)
            'purchaser'
        elsif user.is_a?(Vendor)
            'vendor'
        elsif user.is_a?(Admin)
            'admin'
        else
            'unknown'
        end
    end
end