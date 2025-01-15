class Vendor::AdsController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_ad, only: [:show, :update, :destroy]

  def index
    @ads = current_vendor.ads.includes(:category, :reviews) # Ensure category and reviews are included
    render json: @ads.to_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def show
    render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def create
    # Build the ad with the permitted parameters
    @ad = current_vendor.ads.build(ad_params)
  
    # Save the ad and return appropriate JSON response
    if @ad.save
      render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating]), status: :created
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end
  


  def update
    if params[:ad][:media].present?
      media = params[:ad][:media].is_a?(Array) ? params[:ad][:media] : [params[:ad][:media]]
      @ad.media = media
    end
  
    if @ad.update(ad_params)
      render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end
  
  


  def destroy
    @ad.destroy
    head :no_content
  end

  private

  # app/controllers/vendor/ads_controller.rb
  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Vendor)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end


  def current_vendor
    @current_user
  end

  def set_ad
    @vendor = current_vendor
    if @vendor.nil?
      render json: { error: 'Vendor not found' }, status: :not_found
      return
    end

    @ad = @vendor.ads.find_by(id: params[:id])
    unless @ad
      render json: { error: 'Ad not found' }, status: :not_found
    end
  end

  def ad_params
    params.require(:ad).permit(
      :title, :description, :category_id, :subcategory_id, :price, 
      :quantity, :brand, :manufacturer, :item_length, :item_width, 
      :item_height, :item_weight, :weight_unit, :flagged,
      media: [] # Allow an array of media
    )
  end
end
