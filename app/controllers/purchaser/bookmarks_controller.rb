# app/controllers/purchaser/bookmarks_controller.rb
class Purchaser::BookmarksController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @bookmarks = current_purchaser.bookmarks
    render json: @bookmarks
  end

  def show
    @bookmark = current_purchaser.bookmarks.find(params[:id])
  end

  # POST /purchaser/bookmarks
  def create
    product = Product.find(params[:product_id])
    current_purchaser.bookmark_product(product)
    render json: { message: 'Product bookmarked successfully' }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found
  end

  # DELETE /purchaser/bookmarks/:id
  def destroy
    product = Product.find(params[:id])
    current_purchaser.unbookmark_product(product)
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Bookmark not found' }, status: :not_found
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end
end
