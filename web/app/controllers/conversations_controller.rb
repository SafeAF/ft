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
  
  
  

  # change params sender_id to current_user? no longer permit sender_id?
  def create
    if Conversation.between(current_user, params[:recipient_id]).present?
      @conversation = Conversation.between(current_user, params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_path(@conversation)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:sender_id, :recipient_id)
  end
end
