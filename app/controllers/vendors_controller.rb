class VendorsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:signup]
  
    def signup
      vendor_params_with_categories = vendor_params
      @vendor = Vendor.new(vendor_params_with_categories.except(:category_ids))
      @vendor.categories = Category.find(vendor_params_with_categories[:category_ids])
      
      if @vendor.save
        token = JsonWebToken.encode(vendor_id: @vendor.id, role: 'vendor')
        render json: { token: token, vendor: @vendor }, status: :created
      else
        render json: { errors: @vendor.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def vendor_params
      params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
    end
  end
  