class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin

  # GET /admin/products
  def index
    @products = Product.all_products
    flagged_products = @products.select { |product| product.flagged }
    non_flagged_products = @products.reject { |product| product.flagged }
  
    render json: { flagged: flagged_products, non_flagged: non_flagged_products }
  end
  

  def show
    @product = Product.includes(:vendor, :category, :subcategory, :reviews => :purchaser)
                      .find(params[:id])
                      .tap do |product|
                        product.define_singleton_method(:quantity_sold) do
                          OrderItem.where(product_id: id).count
                        end
                        product.define_singleton_method(:mean_rating) do
                          reviews = Review.where(product_id: id)
                          reviews.average(:rating).to_f
                        end
                      end
    render json: @product.as_json(
      include: {
        vendor: { only: [:fullname] },
        category: { only: [:name] },
        reviews: {
          include: {
            purchaser: { only: [:fullname] }
          },
          only: [:rating, :review]
        }
      },
      methods: [:quantity_sold, :mean_rating]
    )
  end

  # POST /admin/products
  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/products/:id
  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /admin/products/:id
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    head :no_content
  end

  # Update flagged status
  def flag
    @product = Product.find(params[:id])
    @product.update(flagged: true)  # Set flagged to true
    head :no_content
  end

  # Update flagged status
  def restore
    @product = Product.find(params[:id])
    @product.update(flagged: false)  # Set flagged to false
    head :no_content
  end

  # POST /admin/products/:id/notify
  def notify_vendor
    @product = Product.find(params[:id])

    if @product
      # Here you would implement the logic to notify the vendor, e.g., sending an email
      # For simplicity, let's assume we are saving notification data in a Notification model.

      notification_params = {
        product_id: @product.id,
        vendor_id: @product.vendor_id,
        options: params[:options],
        notes: params[:notes]
      }

      # Save notification details (you'll need to create a Notification model for this)
      Notification.create(notification_params)
      
      render json: { message: 'Notification sent successfully' }, status: :ok
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

# GET /admin/products/search
  def search
    if params[:query].present?
      search_terms = params[:query].downcase.split(/\s+/)

      # Build the search conditions
      title_description_conditions = search_terms.map do |term|
        "(LOWER(products.title) LIKE ? OR LOWER(products.description) LIKE ?)"
      end.join(" AND ")

      title_description_search = Product.joins(:vendor)
                                        .where(vendors: { blocked: false })
                                        .where(title_description_conditions, *search_terms.flat_map { |term| ["%#{term}%", "%#{term}%"] })

      category_search = Product.joins(:vendor, :category)
                              .where(vendors: { blocked: false })
                              .where('LOWER(categories.name) ILIKE ?', "%#{params[:query].downcase}%")
                              .select('products.*')

      # Combine results and remove duplicates
      @products = (title_description_search.to_a + category_search.to_a).uniq
    else
      @products = Product.joins(:vendor)
                        .where(vendors: { blocked: false })
    end

    render json: @products
  end



  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, :category_id, :brand, :manufacturer, :package_dimensions, :package_weight, :vendor_id)
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
