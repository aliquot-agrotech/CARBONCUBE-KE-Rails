class Admin::Vendors::ProductsController < ApplicationController
    before_action :set_vendor
  
    def index
      @products = @vendor.products
      render json: @products
    end
  
    private
  
    def set_vendor
      @vendor = Vendor.find(params[:vendor_id])
    end
  end
  