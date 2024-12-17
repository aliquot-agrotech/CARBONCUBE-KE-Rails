class ClickEventsController < ApplicationController
  before_action :set_purchaser_from_token

  def create
    click_event = ClickEvent.new(click_event_params)
    click_event.purchaser_id ||= @current_purchaser&.id # Assign purchaser_id if not already in params

    if click_event.save
      render json: { message: 'Click logged successfully' }, status: :created
    else
      render json: { errors: click_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Extracts purchaser_id from token if Authorization header exists
  def set_purchaser_from_token
    token = request.headers['Authorization']&.split(' ')&.last
    return unless token

    begin
      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      @current_purchaser = Purchaser.find_by(id: decoded['purchaser_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      @current_purchaser = nil
    end
  end

  # Strong parameters
  def click_event_params
    params.permit(:event_type, :product_id, :purchaser_id, metadata: {})
  end
end
