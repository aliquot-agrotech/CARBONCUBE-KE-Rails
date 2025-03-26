class Vendor::AdsController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_ad, only: [:show, :update, :destroy]

  require "image_processing/vips"

  def index
    @ads = current_vendor.ads.includes(:category, :reviews)
    render json: @ads.to_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def show
    render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def create
    params[:ad][:media] = process_and_upload_images(params[:ad][:media]) if params[:ad][:media].present?
    
    @ad = current_vendor.ads.build(ad_params)
    if @ad.save
      render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating]), status: :created
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end  

  def update
    if params[:ad][:media].present?
      params[:ad][:media] = process_and_upload_images(params[:ad][:media])
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
    return render json: { error: 'Vendor not found' }, status: :not_found unless @vendor

    @ad = @vendor.ads.find_by(id: params[:id])
    render json: { error: 'Ad not found' }, status: :not_found unless @ad
  end

  def ad_params
    params.require(:ad).permit(
      :title, :description, :category_id, :subcategory_id, :price, 
      :quantity, :brand, :manufacturer, :item_length, :item_width, 
      :item_height, :item_weight, :weight_unit, :flagged,
      media: [] # Allow an array of media
    )
  end

  # Converts images to WebP and uploads them to Cloudinary
  def process_and_upload_images(images)
    uploaded_urls = []
    temp_folder = Rails.root.join("tmp/uploads/#{Time.now.to_i}")
    FileUtils.mkdir_p(temp_folder)

    Parallel.each(Array(images), in_threads: 4) do |image|
      begin
        temp_file_path = temp_folder.join(image.original_filename)
        File.binwrite(temp_file_path, image.read) # Faster than File.open

        # 🔹 Check sharpness before processing
        unless sharp_enough?(temp_file_path)
          Rails.logger.info "📸 Image is blurry: #{temp_file_path}. Sharpening..."
          sharpen_image(temp_file_path)
        end

        # Resize & Convert to WebP
        optimized_webp_path = optimize_and_convert_to_webp(temp_file_path)
        Rails.logger.info "📂 Optimized and converted to WebP: #{optimized_webp_path}"

        # Upload optimized WebP image in parallel
        uploaded_image = Cloudinary::Uploader.upload(optimized_webp_path, upload_preset: ENV['UPLOAD_PRESET'])
        Rails.logger.info "🚀 Uploaded to Cloudinary: #{uploaded_image['secure_url']}"
        
        uploaded_urls << uploaded_image["secure_url"]
      rescue => e
        Rails.logger.error "❌ Error processing image: #{e.message}"
      end
    end

    FileUtils.rm_rf(temp_folder) # Cleanup temp folder
    Rails.logger.info "🗑️ Temp folder removed: #{temp_folder}"

    uploaded_urls
  end

  # Python sharpness check with logging
  def sharp_enough?(image_path)
    script_path = Rails.root.join("scripts/check_sharpness.py")
    result = `python3 "#{script_path}" "#{image_path}"`.strip  # Ensure paths are quoted
    Rails.logger.info "📸 Checking sharpness for: #{image_path} - Result: #{result}"
    result == "Sharp"  # Expect script to return 'Sharp' or 'Blurry'
  end

  # Python sharpening function with logging
  def sharpen_image(image_path)
    script_path = Rails.root.join("scripts/sharpen_image.py")
    Rails.logger.info "🛠️ Sharpening image: #{image_path} before upload..."
    `python3 "#{script_path}" "#{image_path}"`  # Ensure paths are quoted
    Rails.logger.info "✅ Image sharpened: #{image_path}"
  end
  
  # Optimize image size and convert to WebP using ImageProcessing + Vips
  def optimize_and_convert_to_webp(image_path)
    image_path = image_path.to_s # Ensure it's a string
    webp_path = image_path.sub(/\.\w+$/, ".webp")
  
    ImageProcessing::Vips
      .source(image_path)
      .resize_to_limit(1080, nil) # Resize width to 1080px (height auto-adjusts)
      .convert("webp")
      .saver(quality: 70) # Set WebP compression quality
      .call(destination: webp_path)
  
    webp_path
  end  
end
