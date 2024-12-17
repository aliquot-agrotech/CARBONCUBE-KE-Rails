class ClickEventsController < ApplicationController
  before_action :attempt_authenticate_purchaser, only: [:create]

  def create
    # Create click event with all available parameters
    click_event = ClickEvent.new(click_event_params)

    # Set purchaser_id to nil if authentication failed
    click_event.purchaser_id = @current_user&.id

    if click_event.save
      render json: { message: 'Click logged successfully' }, status: :created
    else
      render json: { errors: click_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Attempt to authenticate the purchaser, but do not halt the request
  def attempt_authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
  rescue ExceptionHandler::InvalidToken
    @current_user = nil
  end

  def click_event_params
    params.permit(:event_type, :product_id, metadata: {})
  end
end
