class Purchaser::ReviewsController < ApplicationController
  before_action :authenticate_purchaser
  before_action :set_review, only: [:show, :update, :destroy]

  # GET /purchaser/reviews
  def index
    @reviews = current_purchaser.reviews
    render json: @reviews
  end

  # GET /purchaser/reviews/:id
  def show
    render json: @review
  end

  # POST /purchaser/reviews
  def create
    @review = current_purchaser.reviews.new(review_params)

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /purchaser/reviews/:id
  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /purchaser/reviews/:id
  def destroy
    @review.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = current_purchaser.reviews.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:ad_id, :rating, :review)
  end

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
  