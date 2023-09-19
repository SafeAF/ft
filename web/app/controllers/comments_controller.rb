class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_commentable
    before_action :find_comment, only: [:edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update, :destroy]
  
    def create
      @comment = @commentable.comments.new(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @commentable, notice: 'Comment was successfully created.'
      else
        redirect_to @commentable, alert: 'Error creating comment.'
      end
    end
  
    def edit
    end
  
    def update
      if @comment.update(comment_params)
        redirect_to @commentable, notice: 'Comment was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @comment.destroy
      redirect_to @commentable, notice: 'Comment was successfully deleted.'
    end
  
    private
  
    def set_commentable
      resource, id = request.path.split('/')[1, 2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
  
    def find_comment
      @comment = Comment.find(params[:id])
    end
  
    def correct_user
      unless @comment.user == current_user
        redirect_to @commentable, alert: 'You are not authorized to perform this action.'
      end
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  