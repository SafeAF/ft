class TimelinesController < ApplicationController
  def show
    @poasts = current_user.timeline_poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
  end  
end
  