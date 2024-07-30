class Admin::VendorsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor, only: [:block, :unblock, :show, :update, :destroy]


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

  # PUT /admin/vendors/:id/block
  def block
    if @vendor
      mean_rating = @vendor.reviews.average(:rating).to_f

      if mean_rating < 3.0
        if @vendor.update(blocked: true)
          render json: { message: 'Vendor was blocked successfully' }, status: :ok
        else
          render json: @vendor.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Vendor cannot be blocked because their mean rating is above 3.0' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Vendor not found' }, status: :not_found
    end
  end

  # PUT /admin/vendors/:id/unblock
  def unblock
    if @vendor
      if @vendor.update(blocked: false)
        render json: { message: 'Vendor was unblocked successfully' }, status: :ok
      else
        render json: @vendor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Vendor not found' }, status: :not_found
    end
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :business_registration_number, category_ids: [])
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_admin
    @current_user
  end
end
