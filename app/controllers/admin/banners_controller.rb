class Admin::BannersController < ApplicationController
  before_action :set_banner, only: [:show, :update, :destroy]

  def index
    @banners = Banner.all
    render json: @banners
  end

  def show
    render json: @banner
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      render json: @banner, status: :created
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  def update
    if @banner.update(banner_params)
      render json: @banner
    else
      render json: @banner.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @banner.destroy
    head :no_content
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:image_url)
  end
end
