class Purchaser::ConversationsController < ApplicationController
  before_action :authenticate_purchaser

  def index
    @conversations = current_purchaser.purchaser_conversations.includes(:admin, :vendor)
    render json: @conversations.as_json(include: [:admin, :vendor, messages: { include: :sender }])
  end

  def show
    @conversation = current_purchaser.purchaser_conversations.find(params[:id])
    render json: @conversation.as_json(include: [:admin, :vendor, messages: { include: :sender }])
  end

  def create
    existing_convo = Conversation.find_by(
      purchaser_id: current_purchaser.id,
      vendor_id: params[:conversation][:vendor_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      render json: existing_convo.as_json(include: [:admin, :vendor, :ad, messages: { include: :sender }]), status: :ok
    else
      @conversation = current_purchaser.purchaser_conversations.build(conversation_params)

      if @conversation.save
        render json: @conversation.as_json(include: [:admin, :vendor, :ad, messages: { include: :sender }]), status: :created
      else
        render json: @conversation.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:vendor_id, :ad_id)
  end

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.purchaser?
  end

  def current_purchaser
    @current_user
  end
end
