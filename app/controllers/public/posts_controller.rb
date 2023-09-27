class Public::PostsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update,:destroy]
  before_action :ensure_guest, only: [:new]

  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    @post = Post.find(params[:id])
    @users = @post.user
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました！"
    else
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を編集しました！"
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path, notice: "投稿を削除しました！"
  end

  private

    # カスタムパラメーターを許可
    def post_params
      params.require(:post).permit(:image, :title, :body)
    end

    # ユーザー認証（本人でない場合は投稿一覧へ飛ばす）
    def ensure_correct_user
      @post = Post.find(params[:id])
      unless @post.user == current_user
        redirect_to posts_path, alert: "不正なアクセスのため、投稿一覧へ移動しました。"
      end
    end

    # ゲストの投稿規制
    def ensure_guest
      @user = User.find(params[:id])
      if @user.name == "Guest"
        redirect_to user_path(current_user), alert: "ゲストログインの方はプロフィール編集出来ません。"
      end
    end

end
