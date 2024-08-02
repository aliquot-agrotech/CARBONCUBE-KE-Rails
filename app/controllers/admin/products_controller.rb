class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin

  # GET /admin/products
  def index
    @products = Product.all  # Fetch all products
    render json: @products
  end

  # GET /admin/products/:id
  def show
    @product = Product.find(params[:id])
    render json: @product
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
  def unflag
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
      title_description_search = Product.joins(:vendor)
                                        .where(vendors: { blocked: false })
                                        .search_by_title_and_description(params[:query])

      category_search = Product.joins(:vendor, :category)
                              .where(vendors: { blocked: false })
                              .where('categories.name ILIKE ?', "%#{params[:query]}%")
                              .select('products.*')

      # Combine results manually
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
