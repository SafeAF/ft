class PoastsController < ApplicationController
    before_action :set_poast, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
	# use .include so as not to make excessive requests
	# use left_joins to include 0 comment poasts
	# and group to make it efficiently aggregated
	def index
  	@poasts = Poast.where(visible: true)
                 .left_joins(:comments)
                 .select('poasts.*, COUNT(comments.id) AS comments_count')
                 .group('poasts.id')
                 .order(created_at: :desc)
                 .page(params[:page]).per(10)
	end

    def showall
      @poasts = Poast.where(visible: true).order(created_at: :desc).page(params[:page]).per(10)
    end
    

    # def index
    #     if params[:username]
    #         @user = User.find_by!(username: params[:username].downcase!)
    #         @poasts = @user.poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
    #     else
    #         @poasts = Poast.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
    #     end
    # end
       
    # GET /poasts/1
    def show
      @poast.increment!(:views)
      @comments = @poast.comments.includes(:replies).where(visible: true).page(params[:page]).per(5)
      @total_comments_and_replies = @comments.to_a.sum { |comment| 1 + comment.replies.count }

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
    
      respond_to do |format|
        if @poast.save
          format.html { redirect_to poast_url(@poast), notice: 'Poast was successfully created.' }
          format.json { render :show, status: :created, location: @poast }
        else
          format.html do
            flash.now[:alert] = @poast.errors.full_messages.join(', ')
            render :new, status: :unprocessable_entity
          end
          format.json { render json: @poast.errors, status: :unprocessable_entity }
        end
      end
    end
    
    def update
      respond_to do |format|
        if @poast.update(poast_params)
          format.html { redirect_to @poast, notice: 'Poast was successfully updated.' }
          format.json { render :show, status: :ok, location: @poast }
        else
          format.html do 
            flash.now[:alert] = @poast.errors.full_messages.join(', ')
            render :edit, status: :unprocessable_entity
          end
          format.json { render json: @poast.errors, status: :unprocessable_entity }
        end
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
  
