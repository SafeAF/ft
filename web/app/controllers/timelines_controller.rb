class TimelinesController < ApplicationController
  before_action :authenticate_user!


  def show
    @poasts = current_user.timeline_poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
    @most_followed_users = User.who_to_follow(current_user)
  end  
end
 