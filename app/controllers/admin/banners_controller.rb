require 'cloudinary'
require 'cloudinary/uploader'
require 'fileutils'
require 'image_processing/vips'

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
    Rails.logger.info "Received params: #{params.inspect}" # Log params
  
    if params[:banner][:image].present?
      uploaded_urls = process_and_upload_images(params[:banner][:image])
  
      if uploaded_urls.any?
        @banner = Banner.new(image_url: uploaded_urls.first)
        if @banner.save
          render json: @banner, status: :created
        else
          Rails.logger.error "Banner save error: #{@banner.errors.full_messages}"
          render json: @banner.errors, status: :unprocessable_entity
        end
      else
        Rails.logger.error "Image upload to Cloudinary failed"
        render json: { error: 'Image upload failed' }, status: :unprocessable_entity
      end
    else
      Rails.logger.error "No image file received in params"
      render json: { error: 'No image file provided' }, status: :unprocessable_entity
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

  # Converts images to WebP and uploads them to Cloudinary
  # Converts images to WebP and uploads them to Cloudinary
def process_and_upload_images(images)
  uploaded_urls = []
  temp_folder = Rails.root.join("tmp/uploads/banners").to_s  # Ensure it's a string
  FileUtils.mkdir_p(temp_folder)

  Array(images).each do |image|
    temp_file_path = File.join(temp_folder, image.original_filename)  # Convert Pathname to String
    File.open(temp_file_path, "wb") { |file| file.write(image.read) }

    # Convert to WebP
    optimized_webp_path = optimize_and_convert_to_webp(temp_file_path.to_s)  # Ensure string

    # Upload to Cloudinary
    uploaded_image = Cloudinary::Uploader.upload(optimized_webp_path, upload_preset: ENV['UPLOAD_PRESET'])
    uploaded_urls << uploaded_image["secure_url"]
  rescue => e
    Rails.logger.error("Failed to process image #{image.original_filename}: #{e.message}")
  end

  FileUtils.rm_rf(temp_folder) # Cleanup temp folder
  uploaded_urls
end


  # Optimize image size and convert to WebP using ImageProcessing + Vips
  def optimize_and_convert_to_webp(image_path)
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
