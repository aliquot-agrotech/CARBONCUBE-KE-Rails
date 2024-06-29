class VendorsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:signup]
    
    def signup
        @vendor = Vendor.new(vendor_params)
        if @vendor.save
            token = JsonWebToken.encode(vendor_id: @vendor.id, role: 'vendor')
            render json: { token: token, vendor: @vendor }, status: :created
        else
            render json: { errors: @vendor.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def vendor_params
        params.require(:vendor).permit(:full_name, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
    end
end