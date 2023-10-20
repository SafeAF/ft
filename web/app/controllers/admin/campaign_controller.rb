class Admin::CampaignController < ApplicationController
    before_action :authenticate_admin!
    before_action :authenticate_user!
    before_action :find_campaign, only: [:edit, :update, :destroy]
  
    def index
      @campaigns = Campaign.all.includes(:advertiser)
    end
  
    def new
      @campaign = Campaign.new
    end
  
    def create
      @campaign = Campaign.new(campaign_params)
      if @campaign.save
        redirect_to admin_campaign_index_path, notice: 'Campaign successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @campaign.update(campaign_params)
        redirect_to admin_campaign_index_path, notice: 'Campaign successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @campaign.destroy
      redirect_to admin_campaign_index_path, notice: 'Campaign successfully deleted.'
    end
  
    private
  
    def authenticate_admin!
      unless current_user&.administrator?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end
  
    def campaign_params
      params.require(:campaign).permit(:name, :description, :budget, :start_date, :end_date, :status, :advertiser_id)
    end
  
    def find_campaign
      @campaign = Campaign.find(params[:id])
    end
  end
  