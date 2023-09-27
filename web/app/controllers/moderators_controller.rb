class ModeratorsController < ApplicationController
  # Make sure to include some form of authentication to ensure only moderators can access this
  before_action :authenticate_user!
  before_action :authenticate_moderator!

  def index
    @flagged_articles = Article.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc)
    @flagged_jobs = Job.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc)
    @flagged_comments = Comment.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc)
    @flagged_listings = Listing.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc)
  end
  
  def hide_item
    item_type = params[:item_type]
    item_id = params[:item_id]
    item = item_type.constantize.find(item_id)

    if item.update(visible: false)
      redirect_to moderators_path, notice: "#{item_type} has been hidden."
    else
      redirect_to moderators_path, alert: "Error hiding #{item_type}."
    end
  end


  def unflag_item
    item_type = params[:item_type]
    item_id = params[:item_id]
    item = item_type.constantize.find(item_id)

    if item.update(flags_count: 0)
      redirect_to moderators_path, notice: "#{item_type} has been unflagged."
    else
      redirect_to moderators_path, alert: "Error unflagging #{item_type}."
    end
  end


  def lock_user
    @user = User.find(params[:user_id])
    @user.update(locked: true)
    redirect_back(fallback_location: moderators_path, notice: "User has been locked.")
  end

  def unlock_user
    @user = User.find(params[:user_id])
    @user.update(locked: false)
    redirect_back(fallback_location: moderators_path, notice: "User has been unlocked.")
  end


  private

  def authenticate_moderator!
    # Replace this with your actual authentication logic for moderators
    unless current_user&.moderator?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end
