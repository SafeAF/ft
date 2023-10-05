class NotificationsController < ApplicationController
    before_action :authenticate_user!
  
    # Display the current user's unread notifications
    ## Not being used as of yet. See users_controller#notifications
    def index
        @notifications = current_user.notifications.unread.order(created_at: :desc)
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
  