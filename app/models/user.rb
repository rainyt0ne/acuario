class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # 自分 → フォローする側の関係性（与フォロー）
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォロワー → 自分のされる側の関係性（被フォロー）
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分のフォロー一覧
  has_many :followings, through: :active_relationships, source: :followed
  # 自分のフォロワー一覧
  has_many :followers, through: :passive_relationships, source: :follower

  # フォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているかの確認
  def following?(user)
    followings.include?(user)
  end

  has_one_attached :profile_image

  # プロフィール画像編集 （無ければサンプル画像添付）
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.png")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    profile_image.variant(realize_to_fill: [width, height], gravity: :center).processed
  end

  # ゲストユーザーの検索（存在しなければランダムパスワードで作成）
  def self.guest
    find_or_create_by!(name: "Guest" ,email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest"
    end
  end

  # ユーザー検索
  def self.search(search)
    if search != ""
      User.where(['name LIKE?', "%#{search}%"])
    end
  end

end
