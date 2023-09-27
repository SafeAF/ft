class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
  

    before_action :check_for_locked_status
    
    private
    
      def check_for_locked_status
        if current_user&.locked?
          sign_out current_user
          redirect_to root_path, alert: "Your account has been locked."
        end
      end
    

    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
  end