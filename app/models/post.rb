class Post < ApplicationRecord

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 50}
  validates :body, presence: true, length: {minimum: 1, maximum: 300}

  has_one_attached :image

  # 投稿画像編集 （無ければサンプル画像添付）
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/no_post_image.png")
      post_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    image.variant(realize_to_fill: [width, height], gravity: :center).processed
  end

  # 投稿検索 (タイトル or 内容　で部分検索)
  def self.search(word)
    if word != ""
      Post.where(['title LIKE? or body LIKE?', "%{word}%", "%{word}%"])
    end
  end

  # Likesテーブルに特定のユーザーが存在するか判定
  def liked_by?(user)
    if user.present?
      likes.exists?(user_id: user.id)
    else
      false
    end
  end

  # Commentテーブルに特定のユーザーのコメントが存在するか判定
  def comment_by?(user)
    if user.present?
      comments.exists?(user_id: user.id)
    else
      false
    end
  end

  # 通知作成（いいね）
  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # 通知がない場合、作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分へのいいねは通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # 通知機能（コメント）
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしているユーザーを取得して全員に通知する
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # 誰もコメントしていない場合は投稿者に通知する
    save_notification_post_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id)
    # 複数回のコメントが想定されるため、1つの投稿に複数回通知する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user.id, id, 'comment'])
    # 通知がない場合、作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user.id,
        action: 'comment'
      )
      # 自分へのいいねは通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

end
