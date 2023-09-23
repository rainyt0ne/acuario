class Post < ApplicationRecord

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :title, presence: true, lemgth: { minimum: 1, maximum: 50}
  validates :body, presence: true, length: {minimum: 1, maximum: 300}

  has_one_attached :post_image

  # 投稿画像編集 （無ければサンプル画像添付）
  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join("app/assets/images/no_post_image.png")
      post_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    post_image.variant(realize_to_fill: [width, height], gravity: :center).processed
  end

  # 投稿検索 (タイトル or 内容　で部分検索)
  def self.search(word)
    if word != ""
      Post.where(['title LIKE? or body LIKE?', "%{word}%", "%{word}%"])
    end
  end

  # Likesテーブルに特定のユーザーが存在するか判定
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

end
