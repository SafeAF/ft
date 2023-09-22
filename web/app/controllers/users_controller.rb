# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:show]
  
    def show
      @user = User.find(params[:id])
      if @user != current_user
        redirect_to root_path, alert: "Access denied."
      end
    end
  end
  