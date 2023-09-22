# app/controllers/users_controller.rb
class UsersController < ApplicationController
 
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user! #, except: [:show]
  before_action :correct_user, only: [:edit, :update]

    # def show
    #   @user = User.find(params[:id])

    # # We want other users to be able to see what each user has been up to
    # #   if @user != current_user
    # #     redirect_to root_path, alert: "Access denied."
    # #   end
    # end


    def show
      @user = User.find(params[:id])
    end
    
    def comments
      @user = User.find(params[:id])
      @comments = @user.comments.order('created_at DESC')
    end
    
    def listings
      @user = User.find(params[:id])
      @listings = @user.listings.order('created_at DESC')
    end
    
    def articles
      @user = User.find(params[:id])
      @articles = @user.articles.order('created_at DESC')
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


      private
    
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end
    
      # Confirm the correct user.
      def correct_user
        redirect_to(root_url) unless @user == current_user
      end
    
      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:bio)
      end
    

end
  