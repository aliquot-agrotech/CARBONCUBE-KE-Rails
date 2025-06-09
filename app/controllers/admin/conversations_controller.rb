class Admin::ConversationsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_conversation, only: [:show]

  # GET /admin/conversations
  def index
    @conversations = Conversation
      .includes(:admin, :purchaser, :vendor)
      .where(admin_id: current_admin.id)
    
    render json: @conversations, each_serializer: ConversationSerializer
  end

  # GET /admin/conversations/:id
  def show
    render json: @conversation, serializer: ConversationSerializer
  end

  # POST /admin/conversations
  def create
    @conversation = Conversation.new(conversation_params)
    @conversation.admin = current_admin

    if @conversation.save
      render json: @conversation, serializer: ConversationSerializer, status: :created
    else
      render json: { errors: @conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:purchaser_id, :vendor_id)
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    unless @current_user.is_a?(Admin)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_admin
    @current_user
  end

  def set_conversation
    @conversation = Conversation.includes(:admin, :purchaser, :vendor, messages: :sender).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Conversation not found" }, status: :not_found
  end
end
