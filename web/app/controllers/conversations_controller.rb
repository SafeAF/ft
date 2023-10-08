class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.involving(current_user)
  end

  def new
    @conversation = Conversation.new
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
    @messages = @conversation.messages.order(:asc)
  end


  def create
    if Conversation.between(current_user, params[:recipient_id]).present?
      @conversation = Conversation.between(current_user, params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:recipient_id)
  end
end
