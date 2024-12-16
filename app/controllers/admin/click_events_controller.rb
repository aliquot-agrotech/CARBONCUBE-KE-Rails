class Admin::ClickEventsController < ApplicationController
  before_action :set_click_event, only: [:show, :destroy]

  # GET /admin/click_events
  def index
    @click_events = ClickEvent.all

    # Optional: Filtering by event_type, product_id, or user_id
    @click_events = @click_events.where(event_type: params[:event_type]) if params[:event_type].present?
    @click_events = @click_events.where(product_id: params[:product_id]) if params[:product_id].present?
    @click_events = @click_events.where(purchaser_id: params[:purchaser_id]) if params[:purchaser_id].present?

    render json: @click_events
  end

  # GET /admin/click_events/:id
  def show
    render json: @click_event
  end

  # DELETE /admin/click_events/:id
  def destroy
    @click_event.destroy
    render json: { message: 'Click event deleted successfully' }, status: :ok
  end

  private

  def set_click_event
    @click_event = ClickEvent.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Click event not found' }, status: :not_found
  end
end
