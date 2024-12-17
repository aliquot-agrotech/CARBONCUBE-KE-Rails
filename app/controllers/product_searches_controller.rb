class ProductSearchesController < ApplicationController
  before_action :authenticate_purchaser, only: [:create] # Ensure purchaser authentication

  def create
    product_search = ProductSearch.new(product_search_params)

    # Assign purchaser_id only if @current_user is present
    product_search.purchaser_id = @current_user.id if @current_user

    if product_search.save
      render json: { message: 'Search logged successfully' }, status: :created
    else
      render json: { errors: product_search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def product_search_params
    params.permit(:search_term)
  end
end
