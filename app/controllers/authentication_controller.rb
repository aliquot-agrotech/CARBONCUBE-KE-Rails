class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        @user = User.find_by(username: params[:username])
        if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id, role: @user.role)
            render json: { token: token, role: @user.role }, status: :ok
        else
            render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
    end

    private

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        decoded = JsonWebToken.decode(header)
        @current_user = User.find(decoded[:user_id]) if decoded
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { error: 'Unauthorized request' }, status: :unauthorized
    end
end
