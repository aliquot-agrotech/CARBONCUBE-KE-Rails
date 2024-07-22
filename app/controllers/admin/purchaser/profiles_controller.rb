class Admin::Purchasers::ProfilesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_purchaser

  # GET /admin/purchasers/:purchaser_id/profile
  def show
    render json: @purchaser
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
end
