class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    # GET /posts
    def index
        @poasts = Poast.where(visible: true).order(created_at: :desc)
    end
      
  
    # GET /posts/1
    def show
    end
  
    # GET /posts/new
    def new
      @post = Post.new
    end
  
    # GET /posts/1/edit
    def edit
    end
  
    # POST /posts
    def create
      @post = current_user.posts.new(post_params)
  
      if @post.save
        redirect_to @post, notice: 'Post was successfully created.'
      else
        render :new
      end
    end
  
    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /poasts/1
    def destroy
        @poast.update(visible: false)
        redirect_to poasts_url, notice: 'Poast was successfully deleted.'
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :subheading, :content, :thumbnail)
    end
  
# Authorization: Ensure current user owns the poast or is a moderator
    def authorize_user!
        unless @poast.user == current_user || current_user.moderator?
        redirect_to @poast, alert: 'Not authorized.'
        end
    end  
end
  