class ModeratorsController < ApplicationController
    # Make sure to include some form of authentication to ensure only moderators can access this
    before_action :authenticate_user!
    
    before_action :authenticate_moderator!
  
    def index
      @flagged_articles = Article.where("flags_count > ?", 0).order(created_at: :desc)
      @flagged_jobs = Job.where("flags_count > ?", 0).order(created_at: :desc)
      @flagged_comments = Comment.where("flags_count > ?", 0).order(created_at: :desc)
      @flagged_listings = Listing.where("flags_count > ?", 0).order(created_at: :desc)
    end
  
    private
  
    def authenticate_moderator!
      # Replace this with your actual authentication logic for moderators
      unless current_user&.moderator?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end
  end
  