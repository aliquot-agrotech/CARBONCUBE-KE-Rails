class AdSearchesController < ApplicationController
  before_action :authenticate_purchaser, only: [:create] # Ensure purchaser authentication

  def create
    ad_search = AdSearch.new(ad_search_params)

    # Assign purchaser_id only if @current_user is present
    ad_search.purchaser_id = @current_user&.id

    if ad_search.save
      render json: { message: 'Search logged successfully' }, status: :created
    else
      render json: { errors: ad_search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Attempt to authenticate the purchaser, but do not halt the request
  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
  rescue ExceptionHandler::InvalidToken
    @current_user = nil
  end

  def ad_search_params
    params.permit(:search_term)
  end
end
