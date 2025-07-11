# app/controllers/buyer/ads_controller.rb
class Buyer::AdsController < ApplicationController
  before_action :set_ad, only: [:show, :seller, :related]

  # GET /buyer/ads
  def index
    per_page = params[:per_page]&.to_i || 500  # ✅ Default to fetching all ads if not specified
    page = params[:page].to_i.positive? ? params[:page].to_i : 1

    @ads = Ad.active.joins(:seller)
            .where(sellers: { blocked: false })
            .where(flagged: false)

    filter_by_category if params[:category_id].present?
    filter_by_subcategory if params[:subcategory_id].present?

    @ads = @ads.limit(per_page).offset((page - 1) * per_page)

    # ✅ Group ads by subcategory for frontend
    grouped_ads = @ads.group_by(&:subcategory_id)

    render json: grouped_ads, each_serializer: AdSerializer
  end

  # GET /buyer/ads/:id
  def show
    @ad = Ad.find(params[:id])
    render json: @ad, serializer: AdSerializer
  end
  

  # GET /buyer/ads/search
  def search
    query = params[:query].to_s.strip
    category_param = params[:category]
    subcategory_param = params[:subcategory]

    ads = Ad.active.joins(:seller, :category, :subcategory)
            .where(sellers: { blocked: false })
            .where(flagged: false)

    if query.present?
      query_words = query.split(/\s+/)
      query_words.each do |word|
        ads = ads.where(
          'ads.title ILIKE :word OR ads.description ILIKE :word OR categories.name ILIKE :word OR subcategories.name ILIKE :word',
          word: "%#{word}%"
        )
      end
    end

    if category_param.present? && category_param != 'All'
      if category_param.to_s.match?(/\A\d+\z/)
        ads = ads.where(category_id: category_param.to_i)
      else
        category = Category.find_by(name: category_param)
        ads = ads.where(category_id: category.id) if category
      end
    end

    if subcategory_param.present? && subcategory_param != 'All'
      if subcategory_param.to_s.match?(/\A\d+\z/)
        ads = ads.where(subcategory_id: subcategory_param.to_i)
      else
        subcategory = Subcategory.find_by(name: subcategory_param)
        ads = ads.where(subcategory_id: subcategory.id) if subcategory
      end
    end

    ads = ads
      .joins(seller: { seller_tier: :tier })
      .select('ads.*, CASE tiers.id
                        WHEN 4 THEN 1
                        WHEN 3 THEN 2
                        WHEN 2 THEN 3
                        WHEN 1 THEN 4
                        ELSE 5
                      END AS tier_priority')
      .includes(
        seller: { seller_tier: :tier },
        category: :ads,
        subcategory: :ads
      )
      .order('tier_priority ASC, ads.created_at DESC')
      .distinct

    render json: ads, each_serializer: AdSerializer
  end

  # GET /buyer/ads/:id/related
  def related
    ad = Ad.find(params[:id])
    
    # Find ads from the same subcategory
    related_ads = Ad.where(subcategory: ad.subcategory)

    # Find ads that share words in the title
    title_words = ad.title.split(' ')
    related_by_title = Ad.where('title ILIKE ANY (array[?])', title_words.map { |word| "%#{word}%" })

    # Combine results, excluding the original ad
    related_ads = related_ads.or(related_by_title).where.not(id: ad.id).distinct

    render json: related_ads
  end

  # GET /buyer/ads/:id/seller
  def seller
    @seller = @ad.seller
    if @seller
      render json: @seller, serializer: SellerSerializer
    else
      render json: { error: 'Seller not found' }, status: :not_found
    end
  end

  private

  def set_ad
    @ad = Ad.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ad not found' }, status: :not_found
  end

  def filter_by_category
    @ads = @ads.where(category_id: params[:category_id])
  end

  def filter_by_subcategory
    @ads = @ads.where(subcategory_id: params[:subcategory_id])
  end

  def ad_params
    params.require(:ad).permit(:title, :description, { media: [] }, :subcategory_id, :category_id, :seller_id, :price, :quantity, :brand, :manufacturer, :item_length, :item_width, :item_height, :item_weight, :weight_unit, :condition)
  end
end
