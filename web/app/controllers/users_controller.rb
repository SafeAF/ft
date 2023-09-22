# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:show]
  
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
    
    

end
  