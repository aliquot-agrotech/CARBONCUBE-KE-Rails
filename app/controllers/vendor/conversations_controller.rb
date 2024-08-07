class Vendor::ConversationsController < ApplicationController
  before_action :authenticate_vendor

  def index
    @conversations = current_vendor.vendor_conversations.includes(:admin, :purchaser)
    render json: @conversations.as_json(include: [:admin, :purchaser, messages: { include: :sender }])
  end

  def show
    @conversation = current_vendor.vendor_conversations.find(params[:id])
    render json: @conversation.as_json(include: [:admin, :purchaser, messages: { include: :sender }])
  end

  def create
    @conversation = current_vendor.vendor_conversations.build(conversation_params)

    if @conversation.save
      render json: @conversation, status: :created
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:purchaser_id)
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.vendor?
  end

  def current_vendor
    @current_user
  end
end
