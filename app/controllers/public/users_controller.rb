class Public::UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest, only: [:edit]
  before_action :ensure_withdrawal_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = Post.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(10)
  end

  def index
    @user = current_user
    @post = Post.new
    @users = User.page(params[:page]).order(created_at: :desc).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "プロフィールを編集しました！"
    else
      render :edit
    end
  end

  # 特定ユーザーのいいねレコードを全て取得
  def likes
    @user = User.find(params[:id])
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    @like_post = Post.find(likes)
  end

  private
    # カスタムパラメーターを許可
    def user_params
      params.require(:user).permit(:name, :email, :introduction, :profile_image)
    end

    # ユーザー認証（本人でない場合はそのユーザーページに飛ばす）
    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    # ゲストの編集規制
    def ensure_guest
      @user = User.find(params[:id])
      if @user.name == "Guest"
        redirect_to user_path(current_user), alert: "ゲストログインの方はプロフィール編集出来ません。"
      end
    end

    # 退会確認画面でのリロード対策
    def ensure_confirm
      if params[:id] == "confirm"
        redirect_to root_path, alert: "退会確認画面でリロードされた為、トップページに戻りました。"
      end
    end

    # 退会済みユーザーページの閲覧制限
    def ensure_withdrawal_user
      @user = User.find_by(id: params[:id])
      if @user.is_withdrawal == true
        redirect_to root_path, alert: "退会済みユーザーページのため、閲覧できません。"
      end
    end

end
