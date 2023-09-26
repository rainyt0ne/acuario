class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page])
    # 未確認の通知レコードだけを取り出した後、未確認から確認済に変更する
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
