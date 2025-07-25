class Admin::ReviewsController < ApplicationController
    before_action :authenticate_admin
    before_action :set_review, only: [:show, :update, :destroy]

    # GET /reviews
    def index
    @reviews = Review.all

    render json: @reviews
    end

    # GET /reviews/1
    def show
    render json: @review
    end

    # POST /reviews
    def create
        @review = Review.new(review_params)

        if @review.save
            render json: @review, status: :created, location: @review
        else
            render json: @review.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /reviews/1
    def update
        if @review.update(review_params)
            render json: @review
        else
            render json: @review.errors, status: :unprocessable_entity
        end
    end

    # DELETE /reviews/1
    def destroy
        @review.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
        @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
        params.require(:review).permit(:ad_id, :buyer_id, :rating, :review)
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
