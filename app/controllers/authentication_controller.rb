# app/controllers/authentication_controller.rb

class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    def login
        @purchaser = Purchaser.find_by(username: params[:username])
        if @purchaser&.authenticate(params[:password])
            token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: @purchaser.role)
            render json: { token: token, role: @purchaser.role }, status: :ok
        else
            render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
    end

    private

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        decoded = JsonWebToken.decode(header)
        @current_purchaser = Purchaser.find(decoded[:purchaser_id]) if decoded
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { error: 'Unauthorized request' }, status: :unauthorized
    end
end
