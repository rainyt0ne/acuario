class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = @post.id
    comment.save
    # 非同期通信のためredirectなし
    @comment = Comment.new
    # コメントした時点で通知作成
    @post.save_notification_comment!(current_user, comment.id)
  end

  def destroy
    Comment.find(params[:id]).destroy
    # 非同期通信のためredirectなし
    @post = Post.find(params[:post_id])
  end

  private
    # カスタムパラメーターを許可
    def comment_params
      params.require(:comment).permit(:comment)
    end

end
