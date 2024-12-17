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

  def attempt_authenticate_purchaser
    begin
      @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    rescue ExceptionHandler::InvalidToken
      @current_user = nil
    end

    # Only render unauthorized if you specifically want to prevent further processing
    # If you want to continue and just log the event, you can remove or comment out this block
    unless @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
      return false
    end
    true
  end

  def click_event_params
    params.require(:click_event).permit(:event_type, :product_id, metadata: {})
  end
end