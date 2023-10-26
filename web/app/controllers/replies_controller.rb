class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:create]
  before_action :set_reply, only: [:destroy, :flag]

  def create
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
    if @reply.user == current_user || current_user.moderator?
      @reply.update!(visible: false)
      flash[:success] = 'Reply has been deleted.'
    else
      flash[:alert] = 'You do not have permission to hide this reply.'
    end

    redirect_to request.referrer || root_path
  end

  def flag
    @reply.increment!(:flags_count)
    redirect_to @reply.comment.commentable, notice: 'Reply was successfully flagged.'
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def set_reply
    @reply = Reply.find(params[:id])
  end

  def reply_params
    params.require(:reply).permit(:content)
  end
end
