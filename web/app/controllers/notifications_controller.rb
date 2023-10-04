class NotificationsController < ApplicationController
    before_action :authenticate_user!
  
    # Display the current user's unread notifications
    def index
      @notifications = current_user.notifications.unread
    end
  
    # Mark a notification as read
    def mark_as_read
      @notification = Notification.find(params[:id])
      
      # Ensure the current user owns the notification
      if @notification.user == current_user
        @notification.update!(status: :read)
        redirect_to polymorphic_path(@notification.notifiable)
      else
        redirect_to root_path, alert: 'You do not have permission to access this resource.'
      end
    end
  end
  