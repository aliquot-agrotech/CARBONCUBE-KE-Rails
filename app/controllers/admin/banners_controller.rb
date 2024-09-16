module Admin
  class BannersController < ApplicationController
    before_action :set_banner, only: [:show, :edit, :update, :destroy]

    def index
      @banners = Banner.all
    end

    def show
      render json: @banner
    end

    def new
      @banner = Banner.new
    end

    def create
      @banner = Banner.new(banner_params)
      if @banner.save
        redirect_to admin_banners_path, notice: 'Banner was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @banner.update(banner_params)
        redirect_to admin_banners_path, notice: 'Banner was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @banner.destroy
      redirect_to admin_banners_path, notice: 'Banner was successfully deleted.'
    end

    private

    def set_banner
      @banner = Banner.find(params[:id])
    end

    def banner_params
      params.require(:banner).permit(:image_url)
    end
  end
end
