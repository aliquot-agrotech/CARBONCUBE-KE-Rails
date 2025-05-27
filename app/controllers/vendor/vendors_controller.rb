class Vendor::VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :update]
  before_action :authenticate_vendor, only: [:identify, :show, :update]

  def identify
    render json: { vendor_id: current_vendor.id }
  end
  
  # GET /vendor/profile
  def show
    render json: current_vendor
  end

  # PATCH/PUT /vendor/profile
  def update
    if current_vendor.update(vendor_params)
      render json: current_vendor
    else
      render json: current_vendor.errors, status: :unprocessable_entity
    end
  end

  # POST /vendor/signup
  def create
    # Process the business permit before assigning to @vendor
    if params[:vendor][:business_permit].present?
      Rails.logger.info "📎 Processing business permit upload..."
      processed_permit_url = process_and_upload_permit(params[:vendor][:business_permit])
      params[:vendor][:business_permit] = processed_permit_url if processed_permit_url
    end

    @vendor = Vendor.new(vendor_params)

    # Log the parameters for debugging
    Rails.logger.info "Vendor Signup Params: #{vendor_params.inspect}"

    if @vendor.save
      # Assign Free Tier (tier_id: 1) automatically
      VendorTier.create(vendor_id: @vendor.id, tier_id: 1, duration_months: 0)

      token = JsonWebToken.encode(vendor_id: @vendor.id, role: 'Vendor')
      render json: { token: token, vendor: @vendor }, status: :created
    else
      # Log errors if save fails
      Rails.logger.error "Vendor Signup Failed: #{@vendor.errors.full_messages.inspect}"
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end


  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :username, :age_group_id, :zipcode, :city, :gender, :description, :business_registration_number, :business_permit, :county_id, :sub_county_id,  category_ids: [])
  end

  def vendor_params_with_categories
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
  end

  def authenticate_vendor
    @current_vendor = VendorAuthorizeApiRequest.new(request.headers).result
    unless @current_vendor
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_vendor
    @current_vendor
  end

  def process_and_upload_permit(image)
    temp_folder = Rails.root.join("tmp/uploads/#{Time.now.to_i}")
    FileUtils.mkdir_p(temp_folder)

    begin
      temp_file_path = temp_folder.join(image.original_filename)
      File.binwrite(temp_file_path, image.read)

      unless sharp_enough?(temp_file_path)
        Rails.logger.info "📸 Permit image is blurry. Sharpening..."
        sharpen_image(temp_file_path)
      end

      optimized_webp_path = optimize_and_convert_to_webp(temp_file_path)
      Rails.logger.info "📂 Converted business permit to WebP: #{optimized_webp_path}"

      uploaded = Cloudinary::Uploader.upload(optimized_webp_path, upload_preset: ENV['UPLOAD_PRESET'])
      Rails.logger.info "🚀 Permit uploaded to Cloudinary: #{uploaded['secure_url']}"

      return uploaded["secure_url"]
    rescue => e
      Rails.logger.error "❌ Error processing business permit: #{e.message}"
      return nil
    ensure
      FileUtils.rm_rf(temp_folder)
      Rails.logger.info "🗑️ Cleaned up temp folder: #{temp_folder}"
    end
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

  