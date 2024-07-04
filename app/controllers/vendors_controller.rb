# app/controllers/vendors_controller.rb

class VendorsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /vendors
  def index
    @vendors = Vendor.all
    render json: @vendors
  end

  # GET /vendors/:id
  def show
    @vendor = Vendor.find(params[:id])
    render json: @vendor
  end

  # POST /vendors
  def create
    vendor_params = vendor_params_with_categories
    @vendor = Vendor.new(vendor_params.except(:category_ids))
    @vendor.categories = Category.find(vendor_params[:category_ids])

    if @vendor.save
      token = JsonWebToken.encode(vendor_id: @vendor.id, role: 'vendor')
      render json: { token: token, vendor: @vendor }, status: :created
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendors/:id
  def update
    @vendor = Vendor.find(params[:id])
    vendor_params = vendor_params_with_categories

    if @vendor.update(vendor_params.except(:category_ids))
      @vendor.categories = Category.find(vendor_params[:category_ids])
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vendors/:id
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    head :no_content
  end


  private

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
  end

  def vendor_params_with_categories
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
  end
end
