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

    def destroy
      @reply = Reply.find(params[:id])
      # Add authorization checks if needed
      if @reply.user == current_user || current_user.moderator?
        @reply.update(visible: false)
        flash[:success] = 'Reply has been hidden.'
      else
        flash[:alert] = 'You do not have permission to hide this reply.'
      end
      # Redirect to the appropriate page
      redirect_to request.referrer || root_path
    end
  
    private
  
    def reply_params
      params.require(:reply).permit(:content)
    end
  end
  