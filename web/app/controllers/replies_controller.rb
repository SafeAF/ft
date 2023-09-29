class RepliesController < ApplicationController
    def create
      @comment = Comment.find(params[:comment_id])
      @reply = @comment.replies.new(reply_params)
      @reply.user = current_user
  
      if @reply.save
        redirect_to @comment.commentable, notice: 'Reply was successfully created.'
      else
        redirect_to @comment.commentable, alert: 'Error creating reply.'
      end
    end
  
    private
  
    def reply_params
      params.require(:reply).permit(:content)
    end
  end
  