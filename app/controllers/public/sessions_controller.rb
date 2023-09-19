# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # ログイン時に実行
  before_action :reject_inactive_user, only: [:create]

  # ゲストログインメソッド
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストとしてログインしました！"
  end

  # 退会済みなら別のメールアドレス使用を促す
  def reject_inactive_user
    @user = User.find_by(email: params[:user][:email])
    if @user
      # ユーザーが存在している場合
      if @user.valid_password?(params[:user][:password]) && !@user.is_withdrawal
        flash[:alert] = "このメールアドレス使用のユーザーは退会済みです。違うメールアドレスをお使い下さい。"
        redirect_to new_user_session_path
      end
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
