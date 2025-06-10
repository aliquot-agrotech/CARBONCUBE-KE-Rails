class Vendor::ConversationsController < ApplicationController
  before_action :authenticate_vendor

  def index
    # Fetch conversations where current vendor is the vendor
    @conversations = Conversation.where(vendor_id: current_vendor.id)
                                .includes(:admin, :purchaser, :ad, messages: { include: :sender })
    
    render json: @conversations.as_json(
      include: [
        :admin, 
        :purchaser, 
        :ad,
        messages: { include: :sender }
      ]
    )
  end

  def show
    @conversation = Conversation.find_by(id: params[:id], vendor_id: current_vendor.id)
    
    unless @conversation
      render json: { error: 'Conversation not found or unauthorized' }, status: :not_found
      return
    end
    
    render json: @conversation.as_json(
      include: [
        :admin, 
        :purchaser, 
        :ad,
        messages: { include: :sender }
      ]
    )
  end

  def create
    # Check if conversation already exists for this vendor, purchaser, and ad
    existing_convo = Conversation.find_by(
      vendor_id: current_vendor.id,
      purchaser_id: params[:conversation][:purchaser_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      render json: existing_convo.as_json(
        include: [
          :admin, 
          :purchaser, 
          :ad, 
          messages: { include: :sender }
        ]
      ), status: :ok
    else
      # Create new conversation with vendor as the vendor (not creator, since purchaser creates)
      @conversation = Conversation.new(conversation_params)
      @conversation.vendor_id = current_vendor.id

      if @conversation.save
        render json: @conversation.as_json(
          include: [
            :admin, 
            :purchaser, 
            :ad, 
            messages: { include: :sender }
          ]
        ), status: :created
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
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user&.is_a?(Vendor)
  end

  def current_vendor
    @current_user
  end
end