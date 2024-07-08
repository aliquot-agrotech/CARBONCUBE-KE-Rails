class Admin::Purchasers::OrdersController < ApplicationController
    before_action :set_purchaser
  
    def index
      @orders = @purchaser.orders
      render json: @orders
    end
  
    private
  
    def set_purchaser
      @purchaser = Purchaser.find(params[:purchaser_id])
    end
  end
  