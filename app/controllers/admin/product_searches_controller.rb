class Admin::ProductSearchesController < ApplicationController
  before_action :set_product_search, only: [:show, :destroy]

  # GET /admin/product_searches
  def index
    @product_searches = ProductSearch.all

    # Optional: Filtering by search_term or purchaser_id
    @product_searches = @product_searches.where("search_term ILIKE ?", "%#{params[:search_term]}%") if params[:search_term].present?
    @product_searches = @product_searches.where(purchaser_id: params[:purchaser_id]) if params[:purchaser_id].present?

    # Use ActiveModelSerializers for rendering
    render json: @product_searches, each_serializer: ProductSearchSerializer, status: :ok
  end

  # GET /admin/product_searches/:id
  def show
    render json: @product_search, serializer: ProductSearchSerializer, status: :ok
  end

  # DELETE /admin/product_searches/:id
  def destroy
    @product_search.destroy
    render json: { message: 'Product search deleted successfully' }, status: :ok
  end

  private

  def set_product_search
    @product_search = ProductSearch.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product search not found' }, status: :not_found
  end
end
