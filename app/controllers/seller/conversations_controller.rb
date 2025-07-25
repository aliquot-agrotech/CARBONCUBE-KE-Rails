class Seller::ConversationsController < ApplicationController
  before_action :authenticate_seller

  def index
    # Fetch ONLY conversations where current seller is the seller
    @conversations = Conversation.where(seller_id: current_seller.id)
                                .includes(:admin, :buyer, :ad, :messages)
                                .order(updated_at: :desc)
    
    # Debug: Log the seller ID and conversations found
    Rails.logger.info "Current Seller ID: #{current_seller.id}"
    Rails.logger.info "Conversations found: #{@conversations.count}"
    @conversations.each do |conv|
      Rails.logger.info "Conversation ID: #{conv.id}, Seller ID: #{conv.seller_id}"
    end
    
    # Simple JSON without complex includes to avoid method errors
    conversations_data = @conversations.map do |conversation|
      {
        id: conversation.id,
        seller_id: conversation.seller_id, # Include this to verify
        created_at: conversation.created_at,
        updated_at: conversation.updated_at,
        admin: conversation.admin,
        buyer: conversation.buyer,
        ad: conversation.ad,
        messages_count: conversation.messages.count,
        last_message: conversation.messages.last&.content
      }
    end
    
    render json: conversations_data
  end

  def show
    @conversation = Conversation.find_by(id: params[:id], seller_id: current_seller.id)
    
    unless @conversation
      render json: { error: 'Conversation not found or unauthorized' }, status: :not_found
      return
    end
    
    # Simple JSON response to avoid method errors
    conversation_data = {
      id: @conversation.id,
      created_at: @conversation.created_at,
      updated_at: @conversation.updated_at,
      admin: @conversation.admin,
      buyer: @conversation.buyer,
      ad: @conversation.ad,
      messages: @conversation.messages.includes(:sender).map do |message|
        {
          id: message.id,
          content: message.content,
          created_at: message.created_at,
          sender_type: message.sender.class.name,
          sender_id: message.sender.id
        }
      end
    }
    
    render json: conversation_data
  end

  def create
    # Check if conversation already exists for this seller, buyer, and ad
    existing_convo = Conversation.find_by(
      seller_id: current_seller.id,
      buyer_id: params[:conversation][:buyer_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      render json: existing_convo.as_json(
        include: [
          :admin, 
          :buyer, 
          :ad, 
          messages: { include: :sender }
        ]
      ), status: :ok
    else
      # Create new conversation with seller as the seller (not creator, since buyer creates)
      @conversation = Conversation.new(conversation_params)
      @conversation.seller_id = current_seller.id

      if @conversation.save
        render json: @conversation.as_json(
          include: [
            :admin, 
            :buyer, 
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
    params.require(:conversation).permit(:buyer_id, :ad_id)
  end

  def authenticate_seller
    @current_user = SellerAuthorizeApiRequest.new(request.headers).result
    
    # Debug logging
    Rails.logger.info "Authenticated user: #{@current_user.inspect}"
    Rails.logger.info "Is Seller?: #{@current_user&.is_a?(Seller)}"
    Rails.logger.info "User ID: #{@current_user&.id}"
    
    unless @current_user&.is_a?(Seller)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_seller
    @current_user
  end
end