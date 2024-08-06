class Admin::VendorsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_vendor, only: [:block, :unblock, :show, :update, :destroy, :analytics, :orders, :products, :reviews]

  def index
    @vendors = Vendor.all
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
    reviews = @vendor.reviews.joins(:product, :purchaser)
                           .where(products: { id: @vendor.products.pluck(:id) })
                           .select('reviews.*, purchasers.fullname AS purchaser_name, products.title AS product_title')
    render json: reviews.as_json(only: [:id, :rating, :review, :created_at],
                                 methods: [:purchaser_name, :product_title])
  end
  

  def products
    products = @vendor.products
    render json: products
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
    # Log the SQL query being executed
    sql_query = @vendor.orders.includes(order_items: :product, purchaser: :orders)
                        .where(order_items: { product_id: @vendor.products.pluck(:id) }).to_sql
    Rails.logger.info "SQL Query: #{sql_query}"
  
    orders = @vendor.orders.includes(order_items: :product, purchaser: :orders)
                      .where(order_items: { product_id: @vendor.products.pluck(:id) })
  
    # Log the count of orders fetched
    Rails.logger.info "Fetched #{orders.size} orders for vendor #{@vendor.id}"
  
    filtered_orders = orders.map do |order|
      {
        id: order.id,
        status: order.status,
        created_at: order.created_at,
        updated_at: order.updated_at,
        mpesa_transaction_code: order.mpesa_transaction_code,
        purchaser: {
          id: order.purchaser.id,
          fullname: order.purchaser.fullname,
          email: order.purchaser.email,
          phone_number: order.purchaser.phone_number
        },
        order_items: order.order_items.select { |item| @vendor.products.exists?(item.product_id) }.map do |item|
          {
            id: item.id,
            quantity: item.quantity,
            product: {
              id: item.product.id,
              title: item.product.title,
              price: item.product.price
            }
          }
        end
      }
    end
  
    # Log the count of filtered orders and items
    Rails.logger.info "Filtered orders count: #{filtered_orders.size}"
    filtered_orders.each do |order|
      Rails.logger.info "Order ID: #{order[:id]} has #{order[:order_items].size} items"
    end
  
    render json: filtered_orders
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

  def fetch_analytics(vendor)
    {
      total_revenue: vendor.orders.joins(:order_items)
                              .where(order_items: { product_id: vendor.products.pluck(:id) })
                              .sum('order_items.quantity * order_items.price'),
      total_orders: vendor.orders.joins(:order_items)
                            .where(order_items: { product_id: vendor.products.pluck(:id) })
                            .distinct.count,
      total_products_sold: vendor.orders.joins(:order_items)
                                  .where(order_items: { product_id: vendor.products.pluck(:id) })
                                  .sum('order_items.quantity'),
      mean_rating: vendor.reviews.joins(:product)
                              .where(products: { id: vendor.products.pluck(:id) })
                              .average(:rating).to_f,
      total_reviews: vendor.reviews.joins(:product)
                               .where(products: { id: vendor.products.pluck(:id) })
                               .group(:rating)
                               .count
                               .values.sum,
      rating_pie_chart: (1..5).map do |rating|
        {
          rating: rating,
          count: vendor.reviews.joins(:product)
                              .where(products: { id: vendor.products.pluck(:id) })
                              .group(:rating)
                              .count[rating] || 0
        }
      end,
      reviews: vendor.reviews.joins(:product, :purchaser)
                      .where(products: { id: vendor.products.pluck(:id) })
                      .select('reviews.*, purchasers.fullname AS purchaser_name')
                      .as_json(only: [:id, :rating, :review, :created_at],
                                include: { purchaser: { only: [:fullname] } })
    }
  end
end
