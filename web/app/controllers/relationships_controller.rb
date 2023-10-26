class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_followed_user, only: [:create]
  before_action :set_relationship, only: [:destroy]

  def create
    if @followed_user
      current_user.follow(@followed_user)
      redirect_to @followed_user
    else
      redirect_to root_path, alert: 'User not found.'
    end
  end

  def destroy
    if @relationship && @relationship.follower == current_user
      current_user.unfollow(@relationship.followed)
      redirect_to @relationship.followed
    else
      redirect_to root_path, alert: 'You do not have permission to unfollow this user.'
    end
  end

  private

  def set_followed_user
    @followed_user = User.find_by(id: params[:followed_id])
  end

  def set_relationship
    @relationship = Relationship.find_by(id: params[:id])
  end
end
