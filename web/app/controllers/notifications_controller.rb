class NotificationsController < ApplicationController
    before_action :authenticate_user!
  
    def index
        @notifications = current_user.notifications.unread.order(created_at: :desc).page(params[:page]).per(10)
    end
    
  
    # Mark a notification as read      
    def mark_as_read
        @notification = Notification.find(params[:id])

        if @notification.user == current_user
            @notification.update!(status: :read)

            respond_to do |format|
            format.turbo_stream
            end
        else
            redirect_to root_path, alert: 'You do not have permission to access this resource.'
        end
    end
  
end
  