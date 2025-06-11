class Purchaser::ConversationsController < ApplicationController
  before_action :authenticate_purchaser

  def index
    # Fetch ONLY conversations where current purchaser is the purchaser
    @conversations = Conversation.where(purchaser_id: current_purchaser.id)
                                .includes(:admin, :vendor, :ad, :messages)
                                .order(updated_at: :desc)
    
    # Debug: Log the purchaser ID and conversations found
    Rails.logger.info "Current Purchaser ID: #{current_purchaser.id}"
    Rails.logger.info "Conversations found: #{@conversations.count}"
    @conversations.each do |conv|
      Rails.logger.info "Conversation ID: #{conv.id}, Purchaser ID: #{conv.purchaser_id}"
    end
    
    # Simple JSON without complex includes to avoid method errors
    conversations_data = @conversations.map do |conversation|
      {
        id: conversation.id,
        purchaser_id: conversation.purchaser_id, # Include this to verify
        created_at: conversation.created_at,
        updated_at: conversation.updated_at,
        admin: conversation.admin,
        vendor: conversation.vendor,
        ad: conversation.ad,
        messages_count: conversation.messages.count,
        last_message: conversation.messages.last&.content
      }
    end
    
    render json: conversations_data
  end

  def show
    @conversation = Conversation.find_by(id: params[:id], purchaser_id: current_purchaser.id)
    
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
      purchaser: @conversation.purchaser,
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
    # Check if conversation already exists for this purchaser, purchaser, and ad
    existing_convo = Conversation.find_by(
      purchaser_id: current_purchaser.id,
      vendor_id: params[:conversation][:vendor_id],
      ad_id: params[:conversation][:ad_id]
    )

    if existing_convo
      render json: existing_convo.as_json(
        include: [
          :admin, 
          :vendor, 
          :ad, 
          messages: { include: :sender }
        ]
      ), status: :ok
    else
      # Create new conversation with purchaser as the purchaser (not creator, since purchaser creates)
      @conversation = Conversation.new(conversation_params)
      @conversation.purchaser_id = current_purchaser.id

      if @conversation.save
        render json: @conversation.as_json(
          include: [
            :admin, 
            :vendor, 
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
    params.require(:conversation).permit(:vendor_id, :ad_id)
  end

  def authenticate_purchaser
    @current_user = PurchaserAuthorizeApiRequest.new(request.headers).result
    
    # Debug logging
    Rails.logger.info "Authenticated user: #{@current_user.inspect}"
    Rails.logger.info "Is Purchaser?: #{@current_user&.is_a?(Purchaser)}"
    Rails.logger.info "User ID: #{@current_user&.id}"
    
    unless @current_user&.is_a?(Purchaser)
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_purchaser
    @current_user
  end
end