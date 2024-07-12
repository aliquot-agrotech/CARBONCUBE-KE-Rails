class Admin::Purchasers::OrdersController < ApplicationController
    before_action :authenticate_admin
    before_action :set_purchaser
  
    def index
      @orders = @purchaser.orders
      render json: @orders
    end
  
    private
  
    def set_purchaser
      @purchaser = Purchaser.find(params[:purchaser_id])
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
  