class Admin::AdsController < ApplicationController
  before_action :authenticate_admin
  
  # GET /admin/ads
  def index
    @ads = Ad.joins(vendor: :vendor_tier) # Join vendor_tiers through vendor
         .joins(:category, :subcategory)
         .where(vendors: { blocked: false })
         .select('ads.*, vendor_tiers.tier_id AS vendor_tier')  # Select tier_id from vendor_tiers

    if params[:category_id].present?
      @ads = @ads.where(category_id: params[:category_id])
    end

    if params[:subcategory_id].present?
      @ads = @ads.where(subcategory_id: params[:subcategory_id])
    end

    flagged_ads = @ads.select { |ad| ad.flagged }
    non_flagged_ads = @ads.reject { |ad| ad.flagged }

    render json: {
      flagged: flagged_ads.as_json(methods: :vendor_tier),
      non_flagged: non_flagged_ads.as_json(methods: :vendor_tier)
    }
  end
  

  def show
    @ad = Ad.includes(:vendor, :category, :subcategory, :reviews => :buyer)
                      .find(params[:id])
                      .tap do |ad|
                        ad.define_singleton_method(:quantity_sold) do
                          OrderItem.where(ad_id: id).sum(:quantity)
                        end
                        ad.define_singleton_method(:mean_rating) do
                          reviews = Review.where(ad_id: id)
                          reviews.average(:rating).to_f
                        end
                      end
    render json: @ad.as_json(
      include: {
        vendor: { only: [:fullname] },
        category: { only: [:name] },
        subcategory: { only: [:name] },
        reviews: {
          include: {
            buyer: { only: [:fullname] }
          },
          only: [:rating, :review]
        }
      },
      methods: [:quantity_sold, :mean_rating]
    )
  end

  # POST /admin/ads
  def create
    @ad = Ad.new(ad_params)
    if @ad.save
      render json: @ad, status: :created
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/ads/:id
  def update
    @ad = Ad.find(params[:id])
    if @ad.update(ad_params)
      render json: @ad
    else
      render json: @ad.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admin/ads/:id
  def destroy
    @ad = Ad.find(params[:id])
    @ad.destroy
    head :no_content
  end

  # Update flagged status
  def flag
    @ad = Ad.find(params[:id])
    @ad.update(flagged: true)  # Set flagged to true
    head :no_content
  end

  # Update flagged status
  def restore
    @ad = Ad.find(params[:id])
    @ad.update(flagged: false)  # Set flagged to false
    head :no_content
  end

  # POST /admin/ads/:id/notify
  def notify_vendor
    @ad = Ad.find(params[:id])

    if @ad
      # Here you would implement the logic to notify the vendor, e.g., sending an email
      # For simplicity, let's assume we are saving notification data in a Notification model.

      notification_params = {
        ad_id: @ad.id,
        vendor_id: @ad.vendor_id,
        options: params[:options],
        notes: params[:notes]
      }

      # Save notification details (you'll need to create a Notification model for this)
      Notification.create(notification_params)
      
      render json: { message: 'Notification sent successfully' }, status: :ok
    else
      render json: { error: 'Ad not found' }, status: :not_found
    end
  end

# GET /admin/ads/search
def search
  if params[:query].present?
    search_terms = params[:query].downcase.split(/\s+/)

    title_description_conditions = search_terms.map do |term|
      "(LOWER(ads.title) LIKE ? OR LOWER(ads.description) LIKE ?)"
    end.join(" AND ")

    title_description_search = Ad.joins(:vendor)
                                      .where(vendors: { blocked: false })
                                      .where(title_description_conditions, *search_terms.flat_map { |term| ["%#{term}%", "%#{term}%"] })

    category_search = Ad.joins(:vendor, :category)
                             .where(vendors: { blocked: false })
                             .where('LOWER(categories.name) ILIKE ?', "%#{params[:query].downcase}%")
                             .select('ads.*')

    subcategory_search = Ad.joins(:vendor, :subcategory)
                                .where(vendors: { blocked: false })
                                .where('LOWER(subcategories.name) ILIKE ?', "%#{params[:query].downcase}%")
                                .select('ads.*')

    # Combine results and remove duplicates
    @ads = (title_description_search.to_a + category_search.to_a + subcategory_search.to_a).uniq
  else
    @ads = Ad.joins(:vendor)
                       .where(vendors: { blocked: false })
  end

  render json: @ads
end



  private

  def ad_params
    params.require(:ad).permit(:title, :description, :price, :quantity, :category_id, :brand, :manufacturer, :package_dimensions, :package_weight, :vendor_id, :condition)
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_admin
    @current_user
  end
end
