class ClickEventsController < ApplicationController
  def create
    click_event = ClickEvent.new(click_event_params)

    if click_event.save
      render json: { message: 'Click logged successfully' }, status: :created
    else
      render json: { errors: click_event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def click_event_params
    params.permit(:event_type, :product_id, :purchaser_id, metadata: {})
  end
end
