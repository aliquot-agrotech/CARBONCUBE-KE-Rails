class AdSearchesController < ApplicationController
  before_action :authenticate_buyer, only: [:create] # Ensure buyer authentication

  def create
    ad_search = AdSearch.new(ad_search_params)

    # Assign buyer_id only if @current_user is present
    ad_search.buyer_id = @current_user&.id

    if ad_search.save
      render json: { message: 'Search logged successfully' }, status: :created
    else
      render json: { errors: ad_search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Attempt to authenticate the buyer, but do not halt the request
  def authenticate_buyer
    @current_user = BuyerAuthorizeApiRequest.new(request.headers).result
  rescue ExceptionHandler::InvalidToken
    @current_user = nil
  end

  def ad_search_params
    params.permit(:search_term)
  end
end
