class Admin::CommentsController < ApplicationController

  def index
    @comments = Comment.all.order(created_at: :desc).page(params[:page]).per(8)
  end

  def destroy
    @comment = Comment.find(params[:id]).destroy
    @comment.destroy
    redirect_to admin_comments_path
  end

end
