
    class Vendor::VendorsController < ApplicationController
      before_action :set_vendor, only: [:show, :update]
      before_action :authenticate_vendor, only: [:identify, :show, :update]
  
      def identify
        render json: { vendor_id: current_vendor.id }
      end
      
      # GET /vendor/profile
      def show
        render json: current_vendor
      end
  
      # PATCH/PUT /vendor/profile
      def update
        if current_vendor.update(vendor_params)
          render json: current_vendor
        else
          render json: current_vendor.errors, status: :unprocessable_entity
        end
      end
  
      # POST /vendor/signup
      def create
        @vendor = Vendor.new(vendor_params)
      
        # Log the parameters for debugging
        Rails.logger.info "Vendor Signup Params: #{vendor_params.inspect}"
      
        if @vendor.save
          # Assign Free Tier (tier_id: 1) automatically
          VendorTier.create(vendor_id: @vendor.id, tier_id: 1, duration_months: 0) 
      
          token = JsonWebToken.encode(vendor_id: @vendor.id, role: 'Vendor')
          render json: { token: token, vendor: @vendor }, status: :created
        else
          # Log errors if save fails
          Rails.logger.error "Vendor Signup Failed: #{@vendor.errors.full_messages.inspect}"
          render json: @vendor.errors, status: :unprocessable_entity
        end
      end
  
      private
  
      def set_vendor
        @vendor = Vendor.find(params[:id])
      end
  
      def vendor_params
        params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :username, :age_group_id, :zipcode, :city, :gender, :description, :business_registration_number, :county_id, :sub_county_id,  category_ids: [])
      end
    
      def vendor_params_with_categories
        params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
      end

      def authenticate_vendor
        @current_vendor = VendorAuthorizeApiRequest.new(request.headers).result
        unless @current_vendor
          render json: { error: 'Not Authorized' }, status: :unauthorized
        end
      end
    
      def current_vendor
        @current_vendor
      end

    end

  