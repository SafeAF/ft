class TimelinesController < ApplicationController
    def show
      @poasts = current_user.timeline_poasts.order(created_at: :desc).page(params[:page]).per(5) # assuming you're using pagination
    end
  end
  