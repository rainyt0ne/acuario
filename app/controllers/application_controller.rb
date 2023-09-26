class ApplicationController < ActionController::Base
  # ログインしていない場合はアクセス禁止
  before_action :authenticate_user!, except: [:top], if: :user_url
  before_action :authenticate_admin!, if: :admin_url

  # ユーザーが送信したHTTPリクエストのパスに"/user" or "/admin"が含まれているか判定
  def user_url
    return false if admin_url
    request.fullpath.include?("/user")
  end

  def admin_url
    request.fullpath.include?("/admin")
  end

end
