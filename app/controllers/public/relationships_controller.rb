class Public::RelationshipsController < ApplicationController

  # フォローする
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  # フォローを外す
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロイー一覧
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers
  end

end
