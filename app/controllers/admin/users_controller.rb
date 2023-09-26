class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(8)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザープロフィールを編集しました！"
    else
      render :edit
    end
  end

  private
    # カスタムパラメーターを許可
    def user_params
      params.require(:user).permit(:name, :email, :introduction, :is_withdrawal)
    end

end
