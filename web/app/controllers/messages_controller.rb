# app/controllers/messages_controller.rb

class MessagesController < ApplicationController
  def index
    @conversation = Conversation.find(params[:conversation_id])
    @messages = @conversation.messages
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    if @message.save
      redirect_to conversation_messages_path(@message.conversation)
    else
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :conversation_id)
  end
end
