class Admin::AdvertisingController < ApplicationController
    before_action :authenticate_admin!  
    before_action :authenticate_user!


    def index
      @advertisers = Advertiser.all
    end
    
    def new
      @advertiser = Advertiser.new
    end
  
    def create
      @advertiser = Advertiser.new(advertiser_params)
      if @advertiser.save
        redirect_to admin_advertising_index_path, notice: 'Advertiser successfully created.'
      else
        render :new
      end
    end
  
    private

    def authenticate_admin!
        unless current_user&.administrator?
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      end

      
    def advertiser_params
      params.require(:advertiser).permit(:name, :contact_info)
    end
  end
  