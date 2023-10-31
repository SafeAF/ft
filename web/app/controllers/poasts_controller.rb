class PoastsController < ApplicationController
    before_action :set_poast, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    def index
        if params[:username]
            @user = User.find_by!(username: params[:username])
            @poasts = @user.poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
        else
            @poasts = Poast.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
        end
    end
      
    # GET /poasts/1
    def show
      # Defined in the before_action :
      @comments = @poast.comments.includes(:replies).where(visible: true).page(params[:page]).per(5)
    end
  
    # GET /poasts/new
    def new
      @poast = Poast.new
    end
  
    # GET /poasts/1/edit
    def edit
      # Defined in the before_action :set_poast
    end
  
    # POST /poasts
    def create
      @poast = current_user.poasts.new(poast_params)
  
      if @poast.save
        redirect_to @poast, notice: 'Poast was successfully created.'
      else
        flash.now[:alert] = @poast.errors.full_messages.join(', ')
        puts @poast.errors.full_messages
        render :new
      end
    end
  
    def update
      if @poast.update(poast_params)
        redirect_to @poast, notice: 'Poast was successfully updated.'
      else
        flash.now[:alert] = @poast.errors.full_messages.join(', ')
        render :edit
      end
    end
  
    def destroy
      if @poast.update(visible: false)
        redirect_to poasts_url, notice: 'Poast was successfully deleted.'
      else
        flash[:alert] = @poast.errors.full_messages.join(', ')
        redirect_to poasts_url
      end
    end

    def flag
      @poast = Poast.find(params[:id])
      @poast.increment!(:flags_count)
    
      redirect_to @poast, notice: 'Poast has been flagged.'
    end
    
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_poast
      @poast = Poast.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def poast_params
      params.require(:poast).permit(:title, :subheading, :content, :thumbnail)
    end
  
    # Authorization: Ensure current user owns the poast or is a moderator
    def authorize_user!
      unless @poast.user == current_user || current_user.moderator?
        redirect_to @poast, alert: 'Not authorized.'
      end
    end
  end
  