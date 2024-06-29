class PurchasersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:signup]
  
    def signup
        @purchaser = Purchaser.new(purchaser_params)
        if @purchaser.save
            token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: @purchaser.role)
            render json: { token: token, purchaser: @purchaser }, status: :created
        else
            render json: { errors: @purchaser.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    private
  
    def purchaser_params
        params.require(:purchaser).permit(:fullname, :username, :phone_number, :email, :location, :password, :password_confirmation)
    end
end
