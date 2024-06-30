class VendorsController < ApplicationController
    def create
        vendor_params = vendor_params_with_categories
        @vendor = Vendor.new(vendor_params.except(:category_ids))
        @vendor.categories = Category.find(vendor_params[:category_ids])
    
        if @vendor.save
            render json: @vendor, status: :created
        else
            render json: @vendor.errors, status: :unprocessable_entity
        end
    end
  
    private
  
    def vendor_params
        params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
    end
  end