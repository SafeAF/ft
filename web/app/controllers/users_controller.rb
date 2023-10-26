class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :comments, :listings, :articles, :edit_bio, :update_bio]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :edit_bio, :update_bio]

  def show 
    # may want to eager load poats and comments also, later. 
    #@user = User.includes(:badges, :poasts, :comments).find_by!(username: params[:id])
    @user = User.includes(:badges).find_by!(username: params[:id])
    @poasts = @user.poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
    @comments = @user.comments.includes(:replies).where(visible: true)
  
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found"
  end

  def comments
    @comments = @user.comments.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
  end
  
  def listings
    @listings = @user.listings.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
  end
  
  def articles
    @articles = @user.articles.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Your profile was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Edit action_text bio, and avatar      
  def edit_bio
  end

  def update_bio
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Bio was successfully updated.'
    else
      render :edit_bio
    end
  end

  # Flag User Action
  def flag
    return redirect_to @user, alert: "You can't flag yourself." if @user == current_user
    @user.increment!(:flags_count)
    redirect_to @user, notice: 'User has been flagged.'
  end


  # User search
  def search
    @q = User.ransack(params[:q])
  
    if params[:q].present?
      @users = @q.result(distinct: true).page(params[:page]).per(10)
    else # Default users shown, most followers, then the most poasts, then everyone else
      all_users = User.default_search
      @users = Kaminari.paginate_array(all_users).page(params[:page]).per(10)
    end
  end
  
  private

  # Setup for username slugs
  def set_user
    @user = User.find_by!(username: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found"
  end

  # Confirm the correct user.
  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:bio, :avatar, :recipient_id)
  end


end
  