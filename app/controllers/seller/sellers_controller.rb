class Seller::SellersController < ApplicationController
  before_action :set_seller, only: [:show, :update]
  before_action :authenticate_seller, only: [:identify, :show, :update, :destroy]

  def identify
    render json: { seller_id: current_seller.id }
  end
  
  # GET /seller/profile
  def show
    render json: current_seller
  end

  # PATCH/PUT /seller/profile
  def update
    if current_seller.update(seller_params)
      render json: current_seller
    else
      render json: current_seller.errors, status: :unprocessable_entity
    end
  end

  # DELETE /seller/:id
  def destroy
    if current_seller.nil?
      Rails.logger.error("Current seller is nil during account deletion.")
      render json: { error: 'Not Authorized' }, status: :unauthorized
      return
    end

    if current_seller.update(deleted: true)
      head :no_content
    else
      render json: { error: 'Failed to delete account' }, status: :unprocessable_entity
    end
  end

  # POST /seller/signup
  def create
    seller_email = params[:seller][:email].downcase.strip

    if Buyer.exists?(email: seller_email)
      return render json: { errors: ['Email is already in use by a buyer'] }, status: :unprocessable_entity
    end

    uploaded_url = nil

    if params[:seller][:document_url].present?
      uploaded_file = params[:seller][:document_url]

      if uploaded_file.size > 5.megabyte
        return render json: { error: "Business permit must be less than 1MB" }, status: :unprocessable_entity
      end

      if uploaded_file.content_type == "application/pdf"
        Rails.logger.info "📄 PDF detected, skipping processing..."
        uploaded_url = upload_file_only(uploaded_file)
      else
        Rails.logger.info "🖼️ Image detected, processing..."
        uploaded_url = process_and_upload_permit(uploaded_file)
      end
    end

    @seller = Seller.new(seller_params)
    @seller.document_url = uploaded_url if uploaded_url

    Rails.logger.info "Seller Signup Params: #{seller_params.inspect}"

    if @seller.save
      SellerTier.create(seller_id: @seller.id, tier_id: 1, duration_months: 0)
      token = JsonWebToken.encode(seller_id: @seller.id, role: 'Seller')
      render json: { token: token, seller: @seller }, status: :created
    else
      Rails.logger.error "Seller Signup Failed: #{@seller.errors.full_messages.inspect}"
      render json: @seller.errors, status: :unprocessable_entity
    end
  end


  private

  def set_seller
    @seller = Seller.find(params[:id])
  end

  def seller_params
    params.require(:seller).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :username, :age_group_id, :zipcode, :city, :gender, :description, :business_registration_number, :document_url, :document_type_id,
    :document_expiry_date, :document_verified, :county_id, :sub_county_id,  category_ids: [])
  end

  def seller_params_with_categories
    params.require(:seller).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :password_confirmation, :business_registration_number, category_ids: [])
  end

  def authenticate_seller
    @current_seller = SellerAuthorizeApiRequest.new(request.headers).result

    if @current_seller.nil?
      render json: { error: 'Not Authorized' }, status: :unauthorized
    elsif @current_seller.deleted?
      render json: { error: 'Account has been deleted' }, status: :unauthorized
    end
  end

  def current_seller
    @current_seller
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

  # Skips image processing for PDFs
  def upload_file_only(file)
    uploaded = Cloudinary::Uploader.upload(file.tempfile.path, resource_type: "raw", upload_preset: ENV['UPLOAD_PRESET'])
    uploaded["secure_url"]
  end 
end

  