class Admin::ConversationsController < ApplicationController
  before_action :authenticate_admin

  def index
    @conversations = Conversation.includes(:admin, :purchaser, :vendor).all
    render json: @conversations, include: [:admin, :purchaser, :vendor, messages: { include: :sender }]
  end

  def show
    @conversation = Conversation.find(params[:id])
    render json: @conversation, include: [:admin, :purchaser, :vendor, messages: { include: :sender }]
  end

  def create
    @conversation = Conversation.new(conversation_params)
    @conversation.admin = current_admin

    if @conversation.save
      render json: @conversation, status: :created
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:purchaser_id, :vendor_id)
  end

  def authenticate_admin
    @current_user = AdminAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user.is_a?(Admin)
  end

  def current_admin
    @current_user
  end
end
