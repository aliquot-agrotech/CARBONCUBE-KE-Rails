class Seller::AdsController < ApplicationController
  before_action :authenticate_seller
  before_action :set_ad, only: [:show, :update, :destroy]

  require "image_processing/vips"

  def index
    @ads = current_seller.ads.includes(:category, :reviews)
    render json: @ads.to_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def show
    render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
  end

  def create
    seller_tier = current_seller.seller_tier

    unless seller_tier && seller_tier.tier
      return render json: { error: "You do not have an active subscription tier. Please upgrade your account to post ads." }, status: :forbidden
    end

    ad_limit = seller_tier.tier.ads_limit || 0
      Rails.logger.info "🔍 Current seller tier: #{seller_tier.tier.name} with ad limit: #{ad_limit}"
    current_ads_count = current_seller.ads.count

    if current_ads_count >= ad_limit
      return render json: { error: "Ad creation limit reached for your current tier (#{ad_limit} ads max)." }, status: :forbidden
    end

    params[:ad][:media] = process_and_upload_images(params[:ad][:media]) if params[:ad][:media].present?

    @ad = current_seller.ads.build(ad_params)

    if @ad.save
      render json: @ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating]), status: :created
    else
      Rails.logger.error "❌ Ad save failed: #{@ad.errors.full_messages.join(', ')}"
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  def update
    ad = current_seller.ads.find(params[:id])
    media_param = params[:ad][:media]

    # Case 1: No media param at all — preserve existing media
    if media_param.nil?
      updated = ad.update(ad_params.except(:media))

    # Case 2: media is a list of Strings (Cloudinary URLs) — replacing media or removing some
    elsif media_param.all? { |m| m.is_a?(String) }
      updated = ad.update(ad_params)

    # Case 3: media includes uploaded files (ActionDispatch::Http::UploadedFile)
    else
      uploaded_urls = process_and_upload_images(media_param)
      merged_media = (ad.media || []) | uploaded_urls
      updated = ad.update(ad_params.except(:media).merge(media: merged_media))
    end

    if updated
      render json: ad.as_json(include: [:category, :reviews], methods: [:quantity_sold, :mean_rating])
    else
      render json: { error: ad.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    @ad.destroy
    head :no_content
  end

  private

  def authenticate_seller
    @current_user = SellerAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_seller
    @current_user
  end

  def set_ad
    @seller = current_seller
    return render json: { error: 'Seller not found' }, status: :not_found unless @seller

    @ad = @seller.ads.find_by(id: params[:id])
    render json: { error: 'Ad not found' }, status: :not_found unless @ad
  end

  def ad_params
    permitted = params.require(:ad).permit(
      :title, :description, :category_id, :subcategory_id, :price, 
      :quantity, :brand, :manufacturer, :item_length, :item_width, 
      :item_height, :item_weight, :weight_unit, :flagged, :condition,
      media: []
    )

    # Convert empty strings to nil for optional numeric fields
    %i[item_length item_width item_height item_weight].each do |field|
      permitted[field] = nil if permitted[field].blank?
    end

    permitted
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
    image_path = image_path.to_s
    base_webp_path = image_path.sub(/\.\w+$/, ".webp")
    max_file_size = 1 * 1024 * 1024 # 1 MB
    quality = 70
    min_quality = 40
    step = 10

    Rails.logger.info "🧩 Starting compression for: #{File.basename(image_path)}"

    loop do
      current_webp_path = base_webp_path.sub(".webp", "_q#{quality}.webp")

      ImageProcessing::Vips
        .source(image_path)
        .resize_to_limit(1080, nil) # Resize to width 1080px
        .convert("webp")
        .saver(quality: quality)
        .call(destination: current_webp_path)

      file_size = File.size(current_webp_path)
      readable_size = (file_size / 1024.0).round(2)

      Rails.logger.info "🔄 Tried quality=#{quality}: #{readable_size} KB (Path: #{current_webp_path})"

      if file_size <= max_file_size
        Rails.logger.info "✅ Compression successful under 1MB at quality=#{quality} (#{readable_size} KB)"
        return current_webp_path
      elsif quality <= min_quality
        Rails.logger.warn "⚠️ Minimum quality reached (#{min_quality}). File still exceeds 1MB (#{readable_size} KB)"
        return current_webp_path
      else
        quality -= step
      end
    end
  end
end
