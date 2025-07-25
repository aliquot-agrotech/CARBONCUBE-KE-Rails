class ClickEventsController < ApplicationController
  before_action :authenticate_buyer, only: [:create]

  def create
    # Create click event with all available parameters
    click_event = ClickEvent.new(click_event_params)

    # Set buyer_id to nil if authentication failed
    click_event.buyer_id = @current_user&.id

    if click_event.save
      render json: { message: 'Click logged successfully' }, status: :created
    else
      render json: { errors: click_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Attempt to authenticate the buyer, but do not halt the request
  def authenticate_buyer
    @current_user = BuyerAuthorizeApiRequest.new(request.headers).result
  rescue ExceptionHandler::InvalidToken
    @current_user = nil
  end

  def click_event_params
    params.permit(:event_type, :ad_id, metadata: {})
  end
end
