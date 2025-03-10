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
    # Check if images are included
    if params[:ad][:media].present?
      uploaded_urls = []
  
      # Create a temporary folder with a timestamp
      temp_folder = Rails.root.join("tmp/uploads/#{Time.now.to_i}")
      FileUtils.mkdir_p(temp_folder)
  
      # Iterate through each uploaded image
      params[:ad][:media].each do |image|
        # Save temporary file
        temp_file_path = temp_folder.join(image.original_filename)
        File.open(temp_file_path, "wb") { |file| file.write(image.read) }
  
        # Upload to Cloudinary with the preset
        uploaded_image = Cloudinary::Uploader.upload(temp_file_path, upload_preset: ENV['UPLOAD_PRESET'])
  
        # Store the secure URL
        uploaded_urls << uploaded_image["secure_url"]
      end
  
      # Cleanup: Delete the temp folder after successful upload
      FileUtils.rm_rf(temp_folder)
  
      # Add media URLs to ad_params before saving
      params[:ad][:media] = uploaded_urls
    end
  
    # Create the Ad
    @ad = current_vendor.ads.build(ad_params)
  
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
