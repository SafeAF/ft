class MessagesController < ApplicationController
  before_action :set_conversation, only: [:create]
  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @message.conversation_id = params[:conversation_id]
    @conversation = Conversation.find(params[:conversation_id])
  
    # Redundant but oh well.
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      redirect_to conversation_path(@conversation), alert: 'Message failed to send.'
    end
  end
  
  
  
  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end
end

