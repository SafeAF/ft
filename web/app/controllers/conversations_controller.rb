class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show]  


  def index
    @conversations = Conversation.involving(current_user).order(updated_at: :desc).page(params[:page]).per(10)
  end
  
  
  def new
    @conversation = Conversation.new
    @conversation.recipient_id = params[:recipient_id] if params[:recipient_id].present?
  end
  

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :desc).page(params[:page]).per(10)
    @message = Message.new
  end
  
  def create
    if Conversation.between(current_user.id, conversation_params[:recipient_id]).present?
      @conversation = Conversation.between(current_user.id, conversation_params[:recipient_id]).first
    else
      @conversation = Conversation.create!(sender_id: current_user.id, recipient_id: conversation_params[:recipient_id])
    end
    redirect_to conversation_path(@conversation)
  end

  # Action to bypass the "new" form
  def start_conversation
    recipient_id = params[:recipient_id]
    conversation = Conversation.between(current_user.id, recipient_id).first_or_create!(sender_id: current_user.id, recipient_id: recipient_id)

    redirect_to conversation_path(conversation)
  end

  private
  
  # Only users part of the conversation can view it
  def authorize_user!
    @conversation = Conversation.find(params[:id])
    unless @conversation.sender_id == current_user.id || @conversation.recipient_id == current_user.id
      redirect_to conversations_path, alert: 'You do not have permission to view this conversation.'
    end
  end

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end
end