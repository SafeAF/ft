class MessagesController < ApplicationController
    def index
      @conversation = Conversation.find(params[:conversation_id])
      @messages = @conversation.messages
    end
    
    def create
      @conversation = Conversation.find(params[:conversation_id])
      @message = @conversation.messages.create!(message_params)
      redirect_to conversation_messages_path(@conversation)
    end
    
    private
    
    def message_params
      params.require(:message).permit(:content).merge(user_id: current_user.id)
    end
end
  