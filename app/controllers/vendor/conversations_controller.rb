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
    existing_convo = Conversation.find_by(
      vendor_id: current_vendor.id,
      purchaser_id: params[:conversation][:purchaser_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      render json: existing_convo.as_json(include: [:admin, :purchaser, :ad, messages: { include: :sender }]), status: :ok
    else
      @conversation = current_purchaser.purchaser_conversations.build(conversation_params)

      if @conversation.save
        render json: @conversation.as_json(include: [:admin, :purchaser, :ad, messages: { include: :sender }]), status: :created
      else
        render json: @conversation.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:purchaser_id, :ad_id)
  end

  def authenticate_vendor
    @current_user = VendorAuthorizeApiRequest.new(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.vendor?
  end

  def current_vendor
    @current_user
  end
end
