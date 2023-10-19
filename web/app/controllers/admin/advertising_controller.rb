class Admin::AdvertisingController < ApplicationController
    before_action :authenticate_admin!  
    before_action :authenticate_user!
    before_action :find_advertiser, only: [:edit, :update, :destroy]
    
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
  
    def edit
        # The @advertiser object is already set by find_advertiser
      end
    
      def update
        if @advertiser.update(advertiser_params)
          redirect_to admin_advertising_index_path, notice: 'Advertiser successfully updated.'
        else
          render :edit
        end
      end
    
      def destroy
        @advertiser.destroy
        redirect_to admin_advertising_index_path, notice: 'Advertiser successfully deleted.'
      end

      
    private
  
    def find_advertiser
      @advertiser = Advertiser.find(params[:id])
    end

    def authenticate_admin!
        unless current_user&.administrator?
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      end

    def advertiser_params
    params.require(:advertiser).permit(:name, :details, :status, :billing_info, :contact_name, :phone, :email)
    end    
  end
  