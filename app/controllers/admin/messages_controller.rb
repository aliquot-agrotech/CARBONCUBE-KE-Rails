class Admin::MessagesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_conversation

  def index
    @messages = @conversation.messages.includes(:sender)
    render json: @messages, each_serializer: MessageSerializer
  end

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_admin
    @message.sender_type = 'Admin' # Set sender_type explicitly

    if @message.save
      render json: @message, serializer: MessageSerializer, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    # Only permit :content as it's the only parameter from user input
    params.require(:message).permit(:content)
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user.is_a?(Admin)
  end

  def current_admin
    @current_user
  end
end
