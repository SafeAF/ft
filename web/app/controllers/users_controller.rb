class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :comments]
  before_action :authenticate_user! #, except: [:show]
  before_action :correct_user, only: [:edit, :update]

    def show
      @user = User.find_by!(username: params[:id])
      @poasts = @user.poasts.where(visible: true).order(created_at: :desc).page(params[:page]).per(5)
      @comments = @user.comments.includes(:replies).where(visible: true)

      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "User not found"
    end
  
    def comments
      @comments = @user.comments.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
    end
    
    def listings
      @user = User.find(params[:id])
      @listings = @user.listings.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
    end
    
    def articles
      @user = User.find(params[:id])
      @articles = @user.articles.order('created_at DESC').page(params[:page]).per(10) # 10 comments per page
    end
  
    # GET /users/1/edit
    def edit
      # Edit action can remain the same, just make sure the form supports Action Text for bio
    end
  
    # PATCH/PUT /users/1 or /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: "Your profile was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

      
  def edit_bio
    @user = User.find(params[:id])
  end

  def update_bio
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Bio was successfully updated.'
    else
      render :edit_bio
    end
  end

  # Flag User Action
  def flag
    @user = User.find(params[:id])
    @user.increment!(:flags_count)
    redirect_to @user, notice: 'User has been flagged.'
  end

  # Lock User Action (only accessible by moderators)
  def lock
    if current_user&.moderator?
      @user = User.find(params[:id])
      @user.update(locked: true)
      redirect_to @user, notice: 'User has been locked.'
    else
      redirect_to @user, alert: 'You are not authorized to perform this action.'
    end
  end

  # initiate DM
  def start_conversation
    recipient = User.find(params[:id])
    conversation = Conversation.between(current_user.id, recipient.id).first

    if conversation.nil?
      conversation = Conversation.create!(sender_id: current_user.id, recipient_id: recipient.id)
    end
    
    redirect_to conversation_path(conversation)
  end



  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_user
  #   @user = User.find(params[:id])
  # end


  def set_user
    @user = User.find_by!(username: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found"
  end


  # Confirm the correct user.
  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:bio, :avatar, :recipient_id)
  end


end
  