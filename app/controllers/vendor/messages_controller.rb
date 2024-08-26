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
    @conversation = current_vendor.conversations.find_by(admin_id: Admin.first.id)
    render json: { error: 'Conversation not found' }, status: :not_found unless @conversation
  end
  

  def message_params
    params.require(:message).permit(:content)
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user.is_a?(Vendor)
  end
  

  def current_vendor
    @current_user
  end
end
