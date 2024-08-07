class Vendor::MessagesController < ApplicationController
  before_action :authenticate_vendor
  before_action :set_conversation

  def index
    @messages = @conversation.messages.includes(:sender)
    render json: @messages.as_json(include: :sender)
  end

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_vendor

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = current_vendor.vendor_conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.vendor?
  end

  def current_vendor
    @current_user
  end
end
