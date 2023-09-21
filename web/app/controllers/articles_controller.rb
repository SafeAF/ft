class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] # Ensure the user is authenticated for actions except index and show
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :verify_owner, only: [:edit, :update, :destroy] # Ensure the current user is the owner for edit, update, and destroy


  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
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
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
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
end
