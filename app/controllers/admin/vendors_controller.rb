class Admin::VendorsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor, only: [:block, :unblock, :show, :update, :destroy, :analytics, :orders, :ads, :reviews]

  def index
    if params[:search_query].present?
      @vendors = Vendor.where("phone_number = :query OR id = :query", query: params[:search_query])
    else
      @vendors = Vendor.all
    end
  
    render json: @vendors.as_json(only: [:id, :fullname, :phone_number, :email, :enterprise_name, :location, :blocked])
  end
  

  def show
    vendor_data = @vendor.as_json(
      only: [:id, :fullname, :phone_number, :email, :enterprise_name, :location, :blocked],
      methods: [:category_names]
    )
    analytics_data = fetch_analytics(@vendor)
    vendor_data.merge!(analytics: analytics_data)
    render json: vendor_data
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      render json: @vendor.as_json(only: [:id, :fullname, :enterprise_name, :location, :blocked]), status: :created
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def update
    if @vendor.update(vendor_params)
      render json: @vendor.as_json(only: [:id, :fullname, :phone_number, :email, :enterprise_name, :location, :blocked])
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @vendor.destroy
    head :no_content
  end

  def reviews
    reviews = @vendor.reviews.joins(:ad, :purchaser)
                           .where(ads: { id: @vendor.ads.pluck(:id) })
                           .select('reviews.*, purchasers.fullname AS purchaser_name, ads.title AS ad_title')
    render json: reviews.as_json(only: [:id, :rating, :review, :created_at],
                                 methods: [:purchaser_name, :ad_title])
  end
  

  def ads
    ads = @vendor.ads
    render json: ads
  end

  def block
    if @vendor
      mean_rating = @vendor.reviews.average(:rating).to_f

      if mean_rating < 3.0
        if @vendor.update(blocked: true)
          render json: @vendor.as_json(only: [:id, :fullname, :enterprise_name, :location, :blocked]), status: :ok
        else
          render json: @vendor.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Vendor cannot be blocked because their mean rating is above 3.0' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Vendor not found' }, status: :not_found
    end
  end

  def unblock
    if @vendor
      if @vendor.update(blocked: false)
        render json: @vendor.as_json(only: [:id, :fullname, :enterprise_name, :location, :blocked]), status: :ok
      else
        render json: @vendor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Vendor not found' }, status: :not_found
    end
  end

  def analytics
    analytics_data = fetch_analytics(@vendor)
    render json: analytics_data
  end

  def orders
  
    orders = @vendor.orders.includes(order_items: [:ad, :order], purchaser: :orders)
                          .where(order_items: { ad_id: @vendor.ads.pluck(:id) })
  
    filtered_orders = orders.map do |order|
      {
        id: order.id,
        status: order.status,
        total_amount: order.total_amount,
        processing_fee: order.processing_fee,
        delivery_fee: order.delivery_fee,
        created_at: order.created_at,
        updated_at: order.updated_at,
        mpesa_transaction_code: order.mpesa_transaction_code,
        purchaser: {
          id: order.purchaser.id,
          fullname: order.purchaser.fullname,
          email: order.purchaser.email,
          phone_number: order.purchaser.phone_number
        },
        order_items: order.order_items
                          .select { |item| @vendor.ads.exists?(item.ad_id) }
                          .map do |item|
          {
            id: item.id,
            quantity: item.quantity,
            price: item.price,
            total_price: item.total_price,
            ad: {
              id: item.ad.id,
              title: item.ad.title,
              vendor_id: item.ad.vendor_id,
              price: item.ad.price
            }
          }
        end
      }
    end
  
    render json: filtered_orders, status: :ok
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:fullname, :phone_number, :email, :enterprise_name, :location, :password, :business_registration_number, category_ids: [])
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end


  def most_clicked_ad(vendor)
    most_clicked = ClickEvent.where(ad_id: vendor.ads.pluck(:id))
                             .group(:ad_id)
                             .order('count_id DESC')
                             .limit(1)
                             .count(:id)
                             .first
  
    if most_clicked
      ad = Ad.find(most_clicked[0])
      {
        ad_id: ad.id,
        title: ad.title,
        total_clicks: most_clicked[1],
        category: ad.category.name
      }
    else
      nil
    end
  end
  
  def fetch_analytics(vendor)
    click_events = ClickEvent.where(ad_id: vendor.ads.pluck(:id))
    click_event_counts = click_events.group(:event_type).count
  
    {
      total_ads: vendor.ads.count,
      total_ads_wishlisted: WishList.where(ad_id: vendor.ads.pluck(:id)).count,
      mean_rating: vendor.reviews.joins(:ad)
                                  .where(ads: { id: vendor.ads.pluck(:id) })
                                  .average(:rating).to_f.round(2),
  
      total_reviews: vendor.reviews.joins(:ad)
                               .where(ads: { id: vendor.ads.pluck(:id) })
                               .group(:rating)
                               .count
                               .values.sum,
      rating_pie_chart: (1..5).map do |rating|
        {
          rating: rating,
          count: vendor.reviews.joins(:ad)
                              .where(ads: { id: vendor.ads.pluck(:id) })
                              .group(:rating)
                              .count[rating] || 0
        }
      end,
      reviews: vendor.reviews.joins(:ad, :purchaser)
                      .where(ads: { id: vendor.ads.pluck(:id) })
                      .select('reviews.*, purchasers.fullname AS purchaser_name')
                      .as_json(only: [:id, :rating, :review, :created_at],
                                include: { purchaser: { only: [:fullname] } }),
  
      # Click Event Breakdown
      ad_clicks: click_event_counts["Ad-Click"] || 0,
      add_to_wish_list: click_event_counts["Add-to-Wish-List"] || 0,
      reveal_vendor_details: click_event_counts["Reveal-Vendor-Details"] || 0,
      total_click_events: click_events.count,
  
      # Most Clicked Ad
      most_clicked_ad: most_clicked_ad(vendor),
  
      vendor_category: vendor.category.name,
      last_ad_posted_at: vendor.ads.order(created_at: :desc).limit(1).pluck(:created_at).first,
      account_age_days: (Time.current.to_date - vendor.created_at.to_date).to_i
    }
  end
  
  
end
