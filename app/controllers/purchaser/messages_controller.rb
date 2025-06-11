class Purchaser::MessagesController < ApplicationController
  before_action :authenticate_purchaser
  before_action :set_conversation

  def index
    @messages = @conversation.messages.includes(:sender).order(:created_at)
    render json: @messages.as_json(include: :sender)
  end

  def create
    @message = @conversation.messages.build(message_params)
    @message.sender = current_purchaser

    if @message.save
      render json: @message.as_json(include: :sender), status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:conversation_id], purchaser_id: current_purchaser.id)
    
    unless @conversation
      render json: { error: 'Conversation not found or unauthorized' }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.is_a?(Purchaser)
  end

  def current_purchaser
    @current_user
  end
end