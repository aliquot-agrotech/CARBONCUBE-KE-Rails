class ClickEventsController < ApplicationController
  before_action :authenticate_purchaser, only: [:create]

  def create
    # Create click event with purchaser_id set to nil if authentication fails
    click_event = ClickEvent.new(click_event_params)
    
    # Assign purchaser_id only if @current_user is present
    click_event.purchaser_id = @current_user&.id

    if click_event.save
      render json: { message: 'Click logged successfully' }, status: :created
    else
      render json: { errors: click_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
  rescue ExceptionHandler::InvalidToken
    # When authentication fails, @current_user remains nil
    @current_user = nil
  ensure
    # If @current_user is not a Purchaser, render unauthorized
    unless @current_user.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def click_event_params
    params.permit(:event_type, :product_id, metadata: {})
  end
end