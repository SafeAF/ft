class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.involving(current_user).order(updated_at: :desc).page(params[:page]).per(10)
  end
  
  

  def new
    @conversation = Conversation.new
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

  private

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end
end