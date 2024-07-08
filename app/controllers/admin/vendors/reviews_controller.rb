class Admin::Vendors::ReviewsController < ApplicationController
    before_action :set_vendor
  
    def index
      @reviews = Review.joins(:product).where(products: { vendor_id: @vendor.id })
      render json: @reviews
    end
  
    private
  
    def set_vendor
      @vendor = Vendor.find(params[:vendor_id])
    end
  end
  