class Purchaser::BookmarksController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @bookmarks = current_purchaser.bookmarks.includes(:product)
    render json: @bookmarks, include: ['product']
  end

  def create
    @bookmark = current_purchaser.bookmarks.build(product_id: params[:product_id])

    if @bookmark.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = current_purchaser.bookmarks.find_by(product_id: params[:product_id])
    @bookmark.destroy
    head :no_content
  end

  private

  def authenticate_purchaser
    @current_user = AuthorizeApiRequest.new(request.headers).result
    unless @current_user && @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end
end
