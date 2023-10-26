class TimelinesController < ApplicationController
  before_action :authenticate_user!

  def show
    @poasts = current_user.timeline_poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
  end  
end
