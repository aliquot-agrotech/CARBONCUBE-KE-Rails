# app/controllers/purchaser/wish_lists_controller.rb
class Purchaser::WishListsController < ApplicationController
  before_action :authenticate_purchaser

  # GET /purchaser/wish_lists
  def index
    @wish_lists = current_purchaser.wish_lists.includes(:ad)
    
    render json: @wish_lists.as_json(include: {
      ad: {
        only: [:id, :title, :price, :rating],
        methods: [:first_media_url] # Include a method to get the first media URL
      }
    })
  end

  # POST /purchaser/wish_lists
  def create
    ad = Ad.find(params[:ad_id])
    current_purchaser.wish_list_ad(ad)
    render json: { message: 'Ad wishlisted successfully' }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ad not found' }, status: :not_found
  end

  # DELETE /purchaser/wish_lists/:id
  def destroy
    ad = Ad.find(params[:id])
    if current_purchaser.unwish_list_ad(ad)
      render json: { message: 'Wish list removed successfully' }, status: :ok
    else
      render json: { error: 'Wish list not found' }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ad not found' }, status: :not_found
  end

  # POST /purchaser/wish_lists/:id/add_to_cart
  def add_to_cart
    ad = Ad.find(params[:id])
    cart_item = CartItem.new(purchaser: current_purchaser, ad: ad)

    if cart_item.save
      render json: { message: 'Ad added to cart' }, status: :created
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ad not found' }, status: :not_found
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user.is_a?(Purchaser)
  end

  def current_purchaser
    @current_user
  end
end
