class Admin::AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!
    
    def index
      # Your logic for the admin dashboard index
    end
    
    private
    
    def authenticate_admin!
      unless current_user&.administrator?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end
  end
  