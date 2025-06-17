class Buyer::ConversationsController < ApplicationController
  before_action :authenticate_buyer

  def index
    # Fetch ONLY conversations where current buyer is the buyer
    @conversations = Conversation.where(buyer_id: current_buyer.id)
                                .includes(:admin, :seller, :ad, :messages)
                                .order(updated_at: :desc)
    
    # Debug: Log the buyer ID and conversations found
    Rails.logger.info "Current Buyer ID: #{current_buyer.id}"
    Rails.logger.info "Conversations found: #{@conversations.count}"
    @conversations.each do |conv|
      Rails.logger.info "Conversation ID: #{conv.id}, Buyer ID: #{conv.buyer_id}"
    end
    
    # Simple JSON without complex includes to avoid method errors
    conversations_data = @conversations.map do |conversation|
      {
        id: conversation.id,
        buyer_id: conversation.buyer_id, # Include this to verify
        created_at: conversation.created_at,
        updated_at: conversation.updated_at,
        admin: conversation.admin,
        seller: conversation.seller,
        ad: conversation.ad,
        messages_count: conversation.messages.count,
        last_message: conversation.messages.last&.content
      }
    end
    
    render json: conversations_data
  end

  def show
    @conversation = Conversation.find_by(id: params[:id], buyer_id: current_buyer.id)
    
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
    existing_convo = Conversation.find_by(
      buyer_id: current_buyer.id,
      seller_id: params[:conversation][:seller_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      # If conversation exists and there's a new message, add it
      if params[:message].present? && params[:message].strip.length > 0
        message = existing_convo.messages.create(
          sender: current_buyer,
          content: params[:message].strip
        )
        Rails.logger.info "Added message to existing conversation: #{message.inspect}"
      end
      
      render json: existing_convo.as_json(
        include: [:admin, :seller, :ad, messages: { include: :sender }]
      ), status: :ok
    else
      @conversation = Conversation.new(conversation_params)
      @conversation.buyer_id = current_buyer.id

      if @conversation.save
        Rails.logger.info "Created new conversation: #{@conversation.id}"
        
        # Create initial message if provided
        if params[:message].present? && params[:message].strip.length > 0
          message = @conversation.messages.create(
            sender: current_buyer,
            content: params[:message].strip
          )
          Rails.logger.info "Created initial message: #{message.inspect}"
          
          if message.errors.any?
            Rails.logger.error "Message creation failed: #{message.errors.full_messages}"
          end
        else
          Rails.logger.warn "No message provided or message was empty"
        end

        render json: @conversation.as_json(
          include: [:admin, :seller, :ad, messages: { include: :sender }]
        ), status: :created
      else
        Rails.logger.error "Conversation creation failed: #{@conversation.errors.full_messages}"
        render json: @conversation.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:seller_id, :ad_id)
  end

  def authenticate_buyer
    @current_user = BuyerAuthorizeApiRequest.new(request.headers).result
    
    # Debug logging
    Rails.logger.info "Authenticated user: #{@current_user.inspect}"
    Rails.logger.info "Is Buyer?: #{@current_user&.is_a?(Buyer)}"
    Rails.logger.info "User ID: #{@current_user&.id}"
    
    unless @current_user&.is_a?(Buyer)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_buyer
    @current_user
  end
end