class MessagesController < ApplicationController
  before_action :set_conversation, only: [:index, :create]

  def index
    @conversation = Conversation.find(params[:conversation_id])
    @messages = @conversation.messages
    @message = Message.new
  end

  # def create
  #   @message = Message.new(message_params)
  #   @message.user_id = current_user.id
  #   if @message.save
  #     respond_to do |format|
  #       format.turbo_stream
  #     end

  #   else
  #     render 'index'
  #   end
  # end


  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @message.conversation_id = @conversation.id
  
    if @message.save
      redirect_to conversation_path(@conversation)
    else
      Rails.logger.debug(@message.errors.full_messages.to_sentence)
      @messages = @conversation.messages
      render 'index'
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

