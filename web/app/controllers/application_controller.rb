class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_for_locked_status
  before_action :fetch_notifications
  before_action :set_global_alert
  
  # Banner dvertisments
  before_action :fetch_banner_ads, unless: :skip_banner_ads?


  # Include notifications on every page if user is signed in.
  def fetch_notifications
    if user_signed_in? # Replace with your actual user authentication check
      @notifications = current_user.notifications.unread.order(created_at: :desc).limit(20)
    end
  end
    
  # Banner ads on every page (almost)
  # def fetch_banner_ads
  #   @banner_ad = Advert.first
  # end
  def fetch_banner_ads
    @banner_ad = Advert.joins(:campaign).where(campaigns: { status: :active }, ad_type: "banner").first
  
    if @banner_ad.present?
      @banner_ad.impressions += 1
      @banner_ad.save!
    end
  end
  

  def skip_banner_ads?
    return true if controller_name == 'home' && action_name == 'index'
    return true if controller_name == 'moderators' # Replace with actual controller name if different
    return true if controller_path.start_with?('admin/') # Assumes all controllers under Admin:: namespace start with 'admin/'
    
    false
  end
  

  private

    
  def set_global_alert
    if (alert = Rails.cache.read('global_alert'))
      flash.now[alert[:alert_type].to_sym] = alert[:message]
    end
  end

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