class RepliesController < ApplicationController
  before_action :authenticate_user!

    def create
      @comment = Comment.find(params[:comment_id])
    
      # Check if the comment already has 5 replies
      if @comment.replies.count >= 5
        redirect_to @comment.commentable, alert: 'Maximum number of replies reached for this comment.'
        return
      end
    
      @reply = @comment.replies.new(reply_params)
      @reply.user = current_user
    
      if @reply.save
        redirect_to @comment.commentable, notice: 'Reply was successfully created.'
      else
        redirect_to @comment.commentable, alert: 'Error creating reply.'
      end
    end
  

    def destroy
      @reply = Reply.find(params[:id])
      # Add authorization checks if needed
      if @reply.user == current_user || current_user.moderator?
        @reply.update(visible: false)
        flash[:success] = 'Reply has been deleted.'
      else
        flash[:alert] = 'You do not have permission to hide this reply.'
      end
      # Redirect to the appropriate page
      redirect_to request.referrer || root_path
    end

    def flag
      @reply = Reply.find(params[:id])
      @reply.increment!(:flags_count)
    
      redirect_to @reply.comment.commentable, notice: 'Reply was successfully flagged.'
    end
    
  
    private
  
    def reply_params
      params.require(:reply).permit(:content)
    end
  end
  