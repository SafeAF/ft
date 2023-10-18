class ModeratorsController < ApplicationController
  # Make sure to include some form of authentication to ensure only moderators can access this
  before_action :authenticate_user!
  before_action :authenticate_moderator!
  before_action :set_user, only: [:assign_badge, :remove_badge]

  
  def index
    @flagged_articles = Article.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_articles]).per(10)
    @flagged_jobs = Job.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_jobs]).per(10)
    @flagged_comments = Comment.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_comments]).per(10)
    @flagged_listings = Listing.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_listings]).per(10)
    @flagged_replies = Reply.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_replies]).per(10)
    @flagged_poasts = Poast.where("flags_count > ?", 0).where(visible: true).order(created_at: :desc).page(params[:page_replies]).per(10)
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

 # User account locking

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

# Add and remove user achievement badges
def search_user
  username = params[:username]
  @user = User.find_by(username: username)

  if @user
    # Prepare additional data if needed
  else
    redirect_to moderators_path, alert: "User not found."
  end
end


def assign_badge
  badge = Badge.find(params[:badge_id])
  user_badge = @user.user_badges.new(badge: badge)

  if user_badge.save
    redirect_to moderators_path, notice: "Badge was successfully assigned to user."
  else
    redirect_to moderators_path, alert: "Failed to assign badge."
  end
end

def remove_badge
  user_badge = @user.user_badges.find_by(badge_id: params[:badge_id])

  if user_badge&.destroy
    redirect_to moderators_path, notice: "Badge was successfully removed from user."
  else
    redirect_to moderators_path, alert: "Failed to remove badge."
  end
end

# Create new types of badges

def new_badge
  
end

def create_badge
  @badge = Badge.new(badge_params)
  if @badge.save
    redirect_to new_badge_moderators_path, notice: 'Badge created successfully.'
  else
    render :new_badge, alert: 'Failed to create badge.'
  end
end

private

def badge_params
  params.require(:badge).permit(:name, :description, :image)
end

def authenticate_moderator!
    # Replace this with your actual authentication logic for moderators
    unless current_user&.moderator?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end
end

def set_user
  @user = User.find(params[:user_id])
end

