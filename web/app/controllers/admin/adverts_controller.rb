class Admin::AdvertsController < ApplicationController
    before_action :authenticate_admin!  # Assuming you have an authenticate_admin! method
    before_action :find_campaign
    before_action :find_advert, only: [:edit, :update, :destroy]
  
    def index
      @adverts = @campaign.adverts
    end
  
    def new
        @advertiser = Advertiser.find(params[:advertiser_id])
        @campaign = Campaign.find(params[:campaign_id])
        @advert = Advert.new
      end
      
    # def new
    #   @advert = @campaign.adverts.new
    # end
  
    def create
      @advert = @campaign.adverts.new(advert_params)
      if @advert.save
        redirect_to admin_advertiser_campaign_adverts_path(@campaign.advertiser, @campaign), notice: 'Advert successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @advert.update(advert_params)
        redirect_to admin_advertiser_campaign_adverts_path(@campaign.advertiser, @campaign), notice: 'Advert successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @advert.destroy
      redirect_to admin_advertiser_campaign_adverts_path(@campaign.advertiser, @campaign), notice: 'Advert successfully deleted.'
    end
  
    private
  

    def authenticate_admin!
        unless current_user&.administrator?
            redirect_to root_path, alert: "You are not authorized to access this page."
        end
    end

    def find_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end
  
    def find_advert
      @advert = Advert.find(params[:id])
    end
  
    def advert_params
      params.require(:advert).permit(:name, :alt_text, :link_url, :start_date, :end_date, 
        :click_count, :impressions, :status, :position, :prominence, :display_locations, :tags, :image)
    end
  end
  