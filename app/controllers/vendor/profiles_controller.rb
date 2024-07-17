class Vendor::ProfilesController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_vendor, only: [:show, :update]

  # GET /vendor/profile
  def show
    render json: @vendor
  end

  # PATCH/PUT /vendor/profile
  def update
    if @vendor.update(vendor_params)
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  private

  def set_vendor
    @vendor = current_vendor
  end

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
  end

  def authenticate_vendor
    @current_vendor = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_vendor && @current_vendor.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_vendor
  end
end
