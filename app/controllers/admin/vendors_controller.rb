class Admin::VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :update, :destroy]

  def index
    @vendors = Vendor.all
    render json: @vendors
  end

  def show
    render json: @vendor
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      render json: @vendor, status: :created
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def update
    if @vendor.update(vendor_params)
      render json: @vendor
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @vendor.destroy
    head :no_content
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :business_registration_number, category_ids: [])
  end
end
