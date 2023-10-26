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
  
    def mark_all_as_read
        current_user.notifications.unread.update_all(status: :read)
        redirect_to notifications_path, notice: 'All notifications have been marked as read.'
    end
end
  