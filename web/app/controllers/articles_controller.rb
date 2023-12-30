class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] # Ensure the user is authenticated for actions except index and show
  before_action :set_article, only: %i[ show edit update destroy pin unpin ]
  before_action :verify_owner, only: [:edit, :update, :destroy] # Ensure the current user is the owner for edit, update, and destroy
  before_action :check_moderator, only: [:pin, :unpin]

  def index
    @q = Article.where(visible: true).ransack(params[:q])
    @articles = @q.result(distinct: true)
                  .left_joins(:comments) # Assuming Article has_many :comments
                  .select('articles.*, COUNT(comments.id) AS comments_count')
                  .group('articles.id')
                  .order(pinned: :desc, created_at: :desc)
                  .page(params[:page]).per(10)
  end


  # GET /articles/1 or /articles/1.json
  def show
    random_increment = rand(1..10)
    @article.increment!(:views, random_increment)
    @article = Article.find(params[:id])
    @article.save!
  
    @comments = @article.comments.includes(:replies).where(visible: true).order(created_at: :desc).page(params[:page]).per(10)
  end
  

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user = current_user

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # DELETE /articles/1 or /articles/1.json
  def destroy
    #@article.destroy
    @article.update(visible: false)

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def flag
    @article = Article.find(params[:id])
    @article.increment!(:flags_count)
    # Add any additional logic like notifying admins, etc.

    redirect_to @article, notice: 'Article has been flagged.'
  end

  # Pin articles

  def pin
    if @article.update(pinned: true)
      redirect_to articles_path, notice: 'Article was successfully pinned.'
    else
      redirect_to articles_path, alert: 'Unable to pin the article.'
    end
  end

  def unpin
    if @article.update(pinned: false)
      redirect_to articles_path, notice: 'Article was successfully unpinned.'
    else
      redirect_to articles_path, alert: 'Unable to unpin the article.'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

     # Verify that the current user is the owner of the article
     def verify_owner
      unless @article.user == current_user || current_user.moderator?
        redirect_to articles_path, alert: "You don't have permission to edit or delete this article."
      end
    end


    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:user_id, :title, :description, :location, :views, :category, :content, :thumbnail)
    end

    def check_moderator
      redirect_to(root_url) unless current_user.moderator?
    end
end
